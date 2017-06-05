//
//  MixerSession.swift
//  Mixer
//
//  Created by Jack Cook on 1/8/16.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//

public let MixerAuthenticatedNotification = Notification.Name("MixerAuthenticatedNotification")

/// Stores data about an authenticated user session.
public class MixerSession {
    
    /// The session's shared instance. This will be nil if nobody is authenticated.
    public static var sharedSession: MixerSession? {
        get {
            if let userData = MixerUserDefaults.standard.data(forKey: "UserData") {
                return MixerSession(user: MixerUser.decode(data: userData))
            }
            
            return nil
        }
    }
    
    /// The authenticated user's data.
    public var user: MixerUser
    
    /// Initializes a session given a user. Won't do anything on its own unless MixerSession.sharedSession is set to it.
    public init(user: MixerUser) {
        self.user = user
    }
    
    /**
     Updates the stored user model.
     
     :param: completion An optional completion block, called when the new user object has been retrieved.
     */
    public func updateStoredUser(completion: ((_ user: MixerUser?, _ error: MixerRequestError?) -> Void)?) {
        MixerClient.sharedClient.users.getUserWithId(self.user.id) { user, error in
            if let user = user {
                self.user = user
                MixerUserDefaults.standard.set(user.encoded, forKey: "UserData")
            }
            
            completion?(user, error)
        }
    }
    
    /**
     Authenticates a user given a username, password, and optional 2FA code.
     
     :param: username The username of the authenticating user.
     :param: password The password of the authenticating user.
     :param: code An optional 2FA code of the authenticating user.
     :param: completion An optional completion block, called when authentication completes.
     */
    public static func authenticate(_ username: String, password: String, code: Int? = nil, completion: ((_ user: MixerUser?, _ error: MixerRequestError?) -> Void)?) {
        var body = [
            "username": username,
            "password": password
        ]
        
        if let code = code {
            body["code"] = String(code)
        }
        
        MixerRequest.request("/users/login", requestType: "POST", body: body as AnyObject, options: [.noAuth, .storeCookies]) { (json, error) in
            guard let json = json , error == nil else {
                completion?(nil, error)
                return
            }
            
            let user = MixerUser(json: json)
            MixerUserDefaults.standard.set(user.encoded, forKey: "UserData")
            
            NotificationCenter.default.post(name: MixerAuthenticatedNotification, object: nil)
            
            completion?(user, error)
        }
    }
    
    /**
     Logs out a user by deleting their stored session locally and on the Mixer servers.
     
     :param: completion An optional completion block, called when logging out completes.
     */
    public static func logout(_ completion: ((_ error: MixerRequestError?) -> Void)?) {
        MixerUserDefaults.standard.removeObject(forKey: "Cookies")
        MixerUserDefaults.standard.removeObject(forKey: "JWT")
        MixerUserDefaults.standard.removeObject(forKey: "UserData")
        
        completion?(nil)
    }
    
    /**
     Registers a new Mixer user. Keep in mind that the user will have to verify their email address.
     
     :param: username The registering user's username.
     :param: password The registering user's password.
     :param: email The registering user's email address.
     :param: completion An optional completion block with the new user's data.
     */
    public static func registerAccount(_ username: String, password: String, email: String, completion: ((_ user: MixerUser?, _ error: MixerRequestError?) -> Void)?) {
        let body = [
            "username": username,
            "password": password,
            "email": email
        ]
        
        MixerRequest.request("/users", requestType: "POST", body: body as AnyObject, options: [.mayNeedCSRF, .storeCookies]) { (json, error) in
            guard error == nil,
                let json = json else {
                    completion?(nil, error)
                    return
            }
            
            let user = MixerUser(json: json)
            MixerUserDefaults.standard.set(user.encoded, forKey: "UserData")
            
            NotificationCenter.default.post(name: MixerAuthenticatedNotification, object: nil)
            
            completion?(user, error)
        }
    }
    
    /**
     Configures user defaults to store data in a suite instead of the default container.
     
     :param: suiteName The suite name identifier.
    */
    @discardableResult
    public static func setUserDefaults(suiteName: String) -> Bool {
        return MixerUserDefaults.set(suiteName: suiteName)
    }
}
