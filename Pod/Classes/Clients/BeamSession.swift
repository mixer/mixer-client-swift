//
//  BeamSession.swift
//  Beam
//
//  Created by Jack Cook on 1/8/16.
//  Copyright © 2016 MCProHosting. All rights reserved.
//

public let BeamAuthenticatedNotification = "BeamAuthenticatedNotification"

/// Stores data about an authenticated user session.
public class BeamSession {
    
    private static var storedSharedSession: BeamSession?
    
    /// The session's shared instance. This will be nil if nobody is authenticated.
    public static var sharedSession: BeamSession? {
        get {
            return storedSharedSession
        }
        
        set {
            storedSharedSession = newValue
            NSUserDefaults.standardUserDefaults().setBool(newValue != nil, forKey: "BeamSessionExists")
        }
    }
    
    /// The authenticated user's data.
    public var user: BeamUser!
    
    /// Initializes a session given a user. Won't do anything on its own unless BeamSession.sharedSession is set to it.
    public init(user: BeamUser) {
        self.user = user
    }
    
    /**
     Authenticates a user given a username, password, and optional 2FA code.
     
     :param: username The username of the authenticating user.
     :param: password The password of the authenticating user.
     :param: code An optional 2FA code of the authenticating user.
     :param: completion An optional completion block, called when authentication completes.
     */
    public static func authenticate(username: String, password: String, code: Int? = nil, completion: ((user: BeamUser?, error: BeamRequestError?) -> Void)?) {
        var body = [
            "username": username,
            "password": password
        ]
        
        if let code = code {
            body["code"] = String(code)
        }
        
        BeamRequest.request("/users/login", requestType: "POST", body: body) { (json, error) in
            guard let json = json where error == nil else {
                completion?(user: nil, error: error)
                return
            }
            
            let user = BeamUser(json: json)
            let session = BeamSession(user: user)
            BeamSession.sharedSession = session
            
            NSNotificationCenter.defaultCenter().postNotificationName(BeamAuthenticatedNotification, object: nil)
            
            completion?(user: user, error: error)
        }
    }
    
    /**
     Logs out a user by deleting their stored session locally and on the Beam servers.
     
     :param: completion An optional completion block, called when logging out completes.
     */
    public static func logout(completion: ((error: BeamRequestError?) -> Void)?) {
        BeamSession.sharedSession = nil
        
        BeamRequest.request("/users/current", requestType: "DELETE") { (json, error) in
            completion?(error: error)
        }
    }
    
    
    /**
     Refreshes any previous sessions that could be found on the device. Useful for persisting sessions between app launches.
     
     :param: completion An optional completion block with the authenticated user's data.
     */
    public static func refreshPreviousSession(completion: ((user: BeamUser?, error: BeamRequestError?) -> Void)?) {
        guard NSUserDefaults.standardUserDefaults().boolForKey("BeamSessionExists") else {
            print("no session exists")
            completion?(user: nil, error: .NotAuthenticated)
            return
        }
        
        BeamRequest.request("/users/current/refresh", requestType: "POST") { (json, error) in
            guard let json = json else {
                completion?(user: nil, error: error)
                return
            }
            
            if let _ = json["username"].string {
                let user = BeamUser(json: json)
                
                let session = BeamSession(user: user)
                BeamSession.sharedSession = session
                
                completion?(user: user, error: error)
            } else {
                completion?(user: nil, error: nil)
            }
        }
    }
    
    /**
     Registers a new Beam user. Keep in mind that the user will have to verify their email address.
     
     :param: username The registering user's username.
     :param: password The registering user's password.
     :param: email The registering user's email address.
     :param: completion An optional completion block with the new user's data.
     */
    public static func registerAccount(username: String, password: String, email: String, completion: ((user: BeamUser?, error: BeamRequestError?) -> Void)?) {
        let body = [
            "username": username,
            "password": password,
            "email": email
        ]
        
        BeamRequest.request("/users", requestType: "POST", body: body) { (json, error) in
            guard error == nil,
                let json = json else {
                    completion?(user: nil, error: error)
                    return
            }
            
            let user = BeamUser(json: json)
            
            let session = BeamSession(user: user)
            BeamSession.sharedSession = session
            
            NSNotificationCenter.defaultCenter().postNotificationName(BeamAuthenticatedNotification, object: nil)
            
            completion?(user: user, error: error)
        }
    }
}
