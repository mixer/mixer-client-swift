//
//  BeamRequest.swift
//  Beam API
//
//  Created by Jack Cook on 3/15/15.
//  Copyright (c) 2016 Beam Interactive, Inc. All rights reserved.
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
    public class func request(_ endpoint: String, requestType: String = "GET", headers: [String: String] = [String: String](), params: [String: String] = [String: String](), body: AnyObject? = nil, options: BeamRequestOptions = [], completion: ((_ json: JSON?, _ error: BeamRequestError?) -> Void)?) {
        BeamRequest.dataRequest("https://beam.pro/api/v1\(endpoint)", requestType: requestType, headers: headers, params: params, body: body, options: options) { (data, error) in
            guard let data = data else {
                completion?(nil, error)
                return
            }
            
            let json = JSON(data: data)
            completion?(json, error)
        }
    }
    
    /**
     Retrieves an image from Beam's servers.
     
     :param: url The URL of the image being retrieved.
     :param: completion An optional completion block with the retrieved image.
     */
    public class func imageRequest(_ url: String, completion: ((_ image: UIImage?, _ error: BeamRequestError?) -> Void)?) {
        BeamRequest.dataRequest(url) { (data, error) in
            guard let data = data, let image = UIImage(data: data) else {
                completion?(nil, error)
                return
            }
            
            completion?(image, error)
        }
    }
    
    /**
     Retrieves data from Beam's servers.
     
     :param: url The URL of the data being retrieved.
     :param: requestType The type of the request being made.
     :param: headers The HTTP headers to be used in the request.
     :param: params The URL parameters to be used in the request.
     :param: body The request body.
     :param: options Any special operations that should be performed for this request.
     :param: completion An optional completion block with retrieved data.
     */
    public class func dataRequest(_ baseURL: String, requestType: String = "GET", headers: [String: String] = [String: String](), params: [String: String] = [String: String](), body: AnyObject? = nil, options: BeamRequestOptions = [], completion: ((_ data: Data?, _ error: BeamRequestError?) -> Void)?) {
        let sessionConfig = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        var url = URL(string: baseURL)!
        url = URLByAppendingQueryParameters(url, queryParameters: params)
        
        var request = URLRequest(url: url)
        request.httpMethod = requestType
        
        if let body = body {
            do {
                request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                completion?(nil, .badRequest(data: nil))
                return
            }
        }
        
        request.addValue("BeamApp/\(version) (iOS; \(deviceName()))", forHTTPHeaderField: "User-Agent")
        
        for (header, val) in headers {
            request.addValue(val, forHTTPHeaderField: header)
        }
        
        if options.contains(.cookieAuth) {
            let storedCookies = UserDefaults.standard.object(forKey: "Cookies") as! [[HTTPCookiePropertyKey: Any]]
            var cookies = [HTTPCookie]()
            
            for properties in storedCookies {
                if let cookie = HTTPCookie(properties: properties) {
                    cookies.append(cookie)
                }
            }
            
            let cookieHeaders = HTTPCookie.requestHeaderFields(with: cookies)
            
            for (header, val) in cookieHeaders {
                request.addValue(val, forHTTPHeaderField: header)
            }
        } else if !options.contains(.noAuth) {
            if let jwt = UserDefaults.standard.string(forKey: "JWT") {
                request.addValue("JWT \(jwt)", forHTTPHeaderField: "Authorization")
            }
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse, let data = data else {
                completion?(nil, .unknown(data: nil))
                return
            }
            
            if options.contains(.storeCookies) {
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: response.allHeaderFields as! [String : String], for: url)
                var storedCookies = [[HTTPCookiePropertyKey: Any]]()
                
                for cookie in cookies {
                    if let properties = cookie.properties {
                        storedCookies.append(properties)
                    }
                }
                
                UserDefaults.standard.set(storedCookies, forKey: "Cookies")
            }
            
            if options.contains(.storeJWT) {
                if let jwt = response.allHeaderFields["x-jwt"] {
                    UserDefaults.standard.set(jwt, forKey: "JWT")
                }
            }
            
            let json = JSON(data: data)
            var requestError: BeamRequestError = .unknown(data: json)
            
            if let error = error {
                switch error._code {
                case -1009: requestError = .offline
                default: break
                }
                
                completion?(nil, requestError)
            } else if response.statusCode != 200 && response.statusCode != 204 {
                switch response.statusCode {
                case 400:
                    requestError = .badRequest(data: json)
                    
                    let component = url.lastPathComponent
                    
                    if requestType == "POST" && component == "users" {
                        if let name = json["name"].string, let details = json["details"].array?[0], let path = details["path"].string, let type = details["type"].string , name == "ValidationError" {
                            switch path {
                            case "payload.email":
                                switch type {
                                case "string.email": requestError = .invalidEmail
                                case "unique": requestError = .takenEmail
                                default: requestError = .unknown(data: json)
                                }
                            case "payload.username":
                                switch type {
                                case "string.min": requestError = .invalidUsername
                                case "unique": requestError = .takenUsername
                                default: requestError = .unknown(data: json)
                                }
                            case "payload.password":
                                switch type {
                                case "string.min", "string.password": requestError = .weakPassword
                                default: requestError = .unknown(data: json)
                                }
                            case "username":
                                switch type {
                                case "reserved": requestError = .reservedUsername
                                default: requestError = .unknown(data: json)
                                }
                            default: requestError = .unknown(data: json)
                            }
                        }
                    }
                case 401:
                    if json["message"] == "Invalid token" {
                        BeamClient.sharedClient.jwt.generateJWTGrant { (error) in
                            guard error == nil else {
                                completion?(data, .invalidCredentials)
                                return
                            }
                            
                            dataRequest(baseURL, requestType: requestType, headers: headers, params: params, body: body, options: options, completion: completion)
                        }
                    } else {
                        requestError = .invalidCredentials
                    }
                case 403: requestError = .accessDenied
                case 404: requestError = .notFound
                case 499: requestError = .requires2FA
                default:
                    print("Unknown status code: \(response.statusCode)")
                    requestError = .unknown(data: json)
                }
                
                completion?(data, requestError)
            } else {
                completion?(data, nil)
            }
        }
        
        task.resume()
    }
    
    /**
     Retrieves the name of the device being used.
     
     :returns: The name of the device being used.
     */
    class func deviceName() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else {
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
    fileprivate class func stringFromQueryParameters(_ queryParameters: [String: String]) -> String {
        var parts = [String]()
        for (name, value) in queryParameters {
            let part = NSString(format: "%@=%@",
                name.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!,
                value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
    
    /**
     Creates a URL from a base URL and URL parameters.
     
     :param: url The base URL.
     :param: queryParameters. The keys and values of the URL parameters.
     :returns: The complete URL.
     */
    fileprivate class func URLByAppendingQueryParameters(_ url: URL!, queryParameters: [String: String]) -> URL {
        let URLString = NSString(format: "%@?%@", url.absoluteString, stringFromQueryParameters(queryParameters))
        return URL(string: URLString as String)!
    }
}
