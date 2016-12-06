//
//  BeamSession.swift
//  Beam
//
//  Created by Jack Cook on 1/8/16.
//  Copyright © 2016 MCProHosting. All rights reserved.
//

public let BeamAuthenticatedNotification = Notification.Name("BeamAuthenticatedNotification")

/// Stores data about an authenticated user session.
public class BeamSession {
    
    /// The session's shared instance. This will be nil if nobody is authenticated.
    public static var sharedSession: BeamSession? {
        get {
            if let user = UserDefaults.standard.object(forKey: "UserData") as? BeamUser {
                return BeamSession(user: user)
            }
            
            return nil
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
    public static func authenticate(_ username: String, password: String, code: Int? = nil, completion: ((_ user: BeamUser?, _ error: BeamRequestError?) -> Void)?) {
        var body = [
            "username": username,
            "password": password
        ]
        
        if let code = code {
            body["code"] = String(code)
        }
        
        BeamRequest.request("/users/login", requestType: "POST", body: body as AnyObject, options: .storeCookies) { (json, error) in
            guard let json = json , error == nil else {
                completion?(nil, error)
                return
            }
            
            let user = BeamUser(json: json)
            UserDefaults.standard.set(user, forKey: "UserData")
            
            NotificationCenter.default.post(name: BeamAuthenticatedNotification, object: nil)
            
            completion?(user, error)
        }
    }
    
    /**
     Logs out a user by deleting their stored session locally and on the Beam servers.
     
     :param: completion An optional completion block, called when logging out completes.
     */
    public static func logout(_ completion: ((_ error: BeamRequestError?) -> Void)?) {
        UserDefaults.standard.set(nil, forKey: "Cookies")
        UserDefaults.standard.set(nil, forKey: "JWT")
        UserDefaults.standard.set(nil, forKey: "UserData")
    }
    
    /**
     Registers a new Beam user. Keep in mind that the user will have to verify their email address.
     
     :param: username The registering user's username.
     :param: password The registering user's password.
     :param: email The registering user's email address.
     :param: completion An optional completion block with the new user's data.
     */
    public static func registerAccount(_ username: String, password: String, email: String, completion: ((_ user: BeamUser?, _ error: BeamRequestError?) -> Void)?) {
        let body = [
            "username": username,
            "password": password,
            "email": email
        ]
        
        BeamRequest.request("/users", requestType: "POST", body: body as AnyObject) { (json, error) in
            guard error == nil,
                let json = json else {
                    completion?(nil, error)
                    return
            }
            
            let user = BeamUser(json: json)
            UserDefaults.standard.set(user, forKey: "UserData")
            
            NotificationCenter.default.post(name: BeamAuthenticatedNotification, object: nil)
            
            completion?(user, error)
        }
    }
}
