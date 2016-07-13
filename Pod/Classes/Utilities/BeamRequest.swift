//
//  BeamRequest.swift
//  Beam API
//
//  Created by Jack Cook on 3/15/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import Foundation
import SwiftyJSON

/// The most low-level class used to make requests to the Beam servers.
public class BeamRequest {
    
    /// The version of the app, to be used in request user agents.
    public static var version = 0.1
    
    /**
     Makes a request to Beam's servers.
     
     :param: endpoint The endpoint of the request being made.
     :param: requestType The type of request to be made.
     :param: headers The HTTP headers to be used in the request.
     :param: params The URL parameters to be used in the request.
     :param: body The request body.
     :param: completion An optional completion block with retrieved JSON data.
     */
    public class func request(endpoint: String, requestType: String = "GET", headers: [String: String] = [String: String](), params: [String: String] = [String: String](), body: AnyObject? = nil, completion: ((json: JSON?, error: BeamRequestError?) -> Void)?) {
        BeamRequest.dataRequest("https://beam.pro/api/v1\(endpoint)", requestType: requestType, headers: headers, params: params, body: body) { (data, error) in
            guard let data = data else {
                completion?(json: nil, error: error)
                return
            }
            
            let json = JSON(data: data)
            completion?(json: json, error: error)
        }
    }
    
    /**
     Retrieves an image from Beam's servers.
     
     :param: url The URL of the image being retrieved.
     :param: completion An optional completion block with the retrieved image.
     */
    public class func imageRequest(url: String, completion: ((image: UIImage?, error: BeamRequestError?) -> Void)?) {
        BeamRequest.dataRequest(url, requestType: "GET") { (data, error) in
            guard let data = data,
                image = UIImage(data: data) else {
                    completion?(image: nil, error: error)
                    return
            }
            
            completion?(image: image, error: error)
        }
    }
    
    /**
     Retrieves NSData from Beam's servers.
     
     :param: url The URL of the data being retrieved.
     :param: requestType The type of the request being made.
     :param: headers The HTTP headers to be used in the request.
     :param: params The URL parameters to be used in the request.
     :param: body The request body.
     :param: completion An optional completion block with retrieved data.
     */
    public class func dataRequest(url: String, requestType: String = "GET", headers: [String: String] = [String: String](), params: [String: String] = [String: String](), body: AnyObject? = nil, completion: ((data: NSData?, error: BeamRequestError?) -> Void)?) {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        var url = NSURL(string: url)!
        url = NSURLByAppendingQueryParameters(url, queryParameters: params)
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = requestType
        
        if let body = body {
            do {
                request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(body, options: [])
            } catch {
                completion?(data: nil, error: .BadRequest)
                return
            }
        }
        
        request.addValue("BeamApp/\(version) (\(deviceName()); iOS)", forHTTPHeaderField: "User-Agent")
        
        for (header, val) in headers {
            request.addValue(val, forHTTPHeaderField: header)
        }
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            guard let response = response as? NSHTTPURLResponse else {
                completion?(data: nil, error: .Unknown)
                return
            }
            
            var requestError: BeamRequestError? = .Unknown
            
            if let error = error {
                switch error.code {
                case -1009:
                    requestError = .Offline
                default:
                    break
                }
                
                completion?(data: nil, error: requestError)
            } else if response.statusCode != 200 && response.statusCode != 204 {
                switch response.statusCode {
                case 400:
                    if let component = url.lastPathComponent {
                        if requestType == "POST" && component == "users" {
                            if let data = data {
                                let jsonData = JSON(data: data)
                                if let name = jsonData["name"].string {
                                    if name == "ValidationError" {
                                        if let details = jsonData["details"].array?[0] {
                                            if let path = details["path"].string, type = details["type"].string {
                                                if path == "payload.email" {
                                                    if type == "string.email" {
                                                        requestError = .InvalidEmail
                                                    } else if type == "unique" {
                                                        requestError = .TakenEmail
                                                    }
                                                } else if path == "payload.username" {
                                                    if type == "string.min" {
                                                        requestError = .InvalidUsername
                                                    } else if type == "unique" {
                                                        requestError = .TakenUsername
                                                    }
                                                } else if path == "payload.password" {
                                                    if type == "string.min" || type == "string.password" {
                                                        requestError = .WeakPassword
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            requestError = .BadRequest
                        }
                    } else {
                        requestError = .BadRequest
                    }
                case 401:
                    requestError = .InvalidCredentials
                case 403:
                    requestError = .AccessDenied
                case 404:
                    requestError = .NotFound
                case 499:
                    requestError = .Requires2FA
                default:
                    print("Unknown status code: \(response.statusCode)")
                    requestError = .Unknown
                }
                
                completion?(data: data, error: requestError)
            } else {
                if let data = data {
                    completion?(data: data, error: nil)
                } else {
                    completion?(data: nil, error: nil)
                }
            }
        })
        
        task.resume()
    }
    
    /**
     Retrieves the name of the device being used.
     
     :returns: The name of the device being used.
     */
    private class func deviceName() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 where value != 0 else {
                return identifier
            }
            
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }
    
    /**
     Creates a parameter string from URL parameters.
     
     :param: queryParameters The keys and values of the URL parameters.
     :returns: The string of the parameters to be appended to the URL.
     */
    private class func stringFromQueryParameters(queryParameters: [String: String]) -> String {
        var parts: [String] = []
        for (name, value) in queryParameters {
            let part = NSString(format: "%@=%@",
                name.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!,
                value.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!)
            parts.append(part as String)
        }
        return parts.joinWithSeparator("&")
    }
    
    /**
     Creates a URL from a base URL and URL parameters.
     
     :param: url The base URL.
     :param: queryParameters. The keys and values of the URL parameters.
     :returns: The complete URL.
     */
    private class func NSURLByAppendingQueryParameters(url: NSURL!, queryParameters: [String: String]) -> NSURL {
        let URLString = NSString(format: "%@?%@", url.absoluteString, self.stringFromQueryParameters(queryParameters))
        return NSURL(string: URLString as String)!
    }
}
