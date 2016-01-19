//
//  BeamSession.swift
//  Beam
//
//  Created by Jack Cook on 1/8/16.
//  Copyright © 2016 MCProHosting. All rights reserved.
//

public let BeamAuthenticatedNotification = "BeamAuthenticatedNotification"

public class BeamSession {
    
    // sharedSession will be nil if nobody is authenticated
    private static var storedSharedSession: BeamSession?
    public static var sharedSession: BeamSession? {
        get {
            return storedSharedSession
        }
        
        set {
            storedSharedSession = newValue
            NSUserDefaults.standardUserDefaults().setBool(newValue != nil, forKey: "BeamSessionExists")
        }
    }
    
    public var channel: BeamChannel!
    public var user: BeamUser!
    
    public init(sessionChannel: BeamChannel, sessionUser: BeamUser) {
        channel = sessionChannel
        user = sessionUser
    }
    
    public static func authenticate(username: String, password: String, completion: (user: BeamUser?, error: BeamRequestError?) -> Void) {
        self.authenticate(username, password: password, code: nil, deviceToken: nil, completion: completion)
    }
    
    public static func authenticate(username: String, password: String, deviceToken: String?, completion: (user: BeamUser?, error: BeamRequestError?) -> Void) {
        self.authenticate(username, password: password, code: nil, deviceToken: deviceToken, completion: completion)
    }
    
    public static func authenticate(username: String, password: String, code: Int?, completion: (user: BeamUser?, error: BeamRequestError?) -> Void) {
        self.authenticate(username, password: password, code: code, deviceToken: nil, completion: completion)
    }
    
    public static func authenticate(username: String, password: String, code: Int?, deviceToken: String?, completion: (user: BeamUser?, error: BeamRequestError?) -> Void) {
        let body = "username=\(username)&password=\(password)" + (code == nil ? "" : "&code=\(code!)")
        var headers = [String: String]()
        
        if let token = deviceToken {
            headers["X-Device-Token"] = token
        }
        
        BeamRequest.request("/users/login", requestType: "POST", headers: headers, params: [String: String](), body: body) { (json, error) -> Void in
            guard error == nil,
                let json = json else {
                    completion(user: nil, error: error)
                    return
            }
            
            if let error = json["error"].string {
                switch error {
                    case "2fa":
                        completion(user: nil, error: .Requires2FA)
                    case "credentials":
                        completion(user: nil, error: .InvalidCredentials)
                    default:
                        print("Auth error from server: \(error)")
                        completion(user: nil, error: .Unknown)
                }
            } else {
                let user = BeamUser(json: json)
                
                BeamClient.sharedClient.channels.getChannelWithToken(user.username, completion: { (channel, error) -> Void in
                    guard let channel = channel else {
                        completion(user: nil, error: error)
                        return
                    }
                    
                    let session = BeamSession(sessionChannel: channel, sessionUser: user)
                    
                    BeamSession.sharedSession = session
                    completion(user: user, error: error)
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(BeamAuthenticatedNotification, object: nil)
                })
            }
        }
    }
    
    public static func logout(completion: (error: BeamRequestError?) -> Void) {
        BeamSession.sharedSession = nil
        
        BeamRequest.request("/users/current", requestType: "DELETE") { (json, error) -> Void in
            completion(error: error)
        }
    }
    
    public static func refreshPreviousSession(completion: (user: BeamUser?, error: BeamRequestError?) -> Void) {
        guard NSUserDefaults.standardUserDefaults().boolForKey("BeamSessionExists") else {
            print("no session exists")
            completion(user: nil, error: nil)
            return
        }
        
        BeamRequest.request("/users/current/refresh", requestType: "POST") { (json, error) -> Void in
            guard let json = json else {
                completion(user: nil, error: error)
                return
            }
            
            if let _ = json["username"].string {
                let user = BeamUser(json: json)
                
                BeamClient.sharedClient.channels.getChannelWithToken(user.username, completion: { (channel, error) -> Void in
                    guard let channel = channel else {
                        completion(user: nil, error: error)
                        return
                    }
                    
                    let session = BeamSession(sessionChannel: channel, sessionUser: user)
                    
                    BeamSession.sharedSession = session
                    completion(user: user, error: error)
                })
            } else {
                completion(user: nil, error: nil)
            }
        }
    }
}
