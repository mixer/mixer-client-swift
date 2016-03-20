//
//  UsersRoutes.swift
//  Beam
//
//  Created by Jack Cook on 1/8/16.
//  Copyright © 2016 MCProHosting. All rights reserved.
//

import SwiftyJSON

public class UsersRoutes {
    
    // MARK: Acting on User Data
    
    public func forgotPassword(email: String, completion: ((error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/users/reset", requestType: "POST", body: "email=\(email)") { (json, error) -> Void in
            completion?(error: error)
        }
    }
    
    public func updatePreferences(id: Int, preferences: String, completion: ((error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/users/\(id)/preferences", requestType: "POST", body: preferences) { (json, error) -> Void in
            completion?(error: error)
        }
    }
    
    public func updateNotificationPreferences(id: Int, enable: Bool, completion: ((error: BeamRequestError?) -> Void)?) {
        getPreferences(id) { (preferences, error) -> Void in
            guard let preferences = preferences,
                transports = preferences["channel:notifications"]?["transports"] as? [String] else {
                    completion?(error: error)
                    return
            }
            
            var transportString = "channel:notifications={\"transports\":["
            
            if enable {
                for transport in transports {
                    transportString += "\"\(transport)\","
                }
                
                transportString.removeAtIndex(transportString.endIndex.predecessor())
                
                if !transports.contains("push") {
                    transportString += ",\"push\""
                }
            } else {
                for transport in transports where transport != "push" {
                    transportString += "\"\(transport)\","
                }
                
                transportString.removeAtIndex(transportString.endIndex.predecessor())
            }
            
            transportString += "]}"
            
            self.updatePreferences(id, preferences: transportString, completion: { (error) -> Void in
                completion?(error: error)
            })
        }
    }
    
    public func updateProfile(id: Int, settings: String, completion: ((user: BeamUser?, error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/users/\(id)", requestType: "PUT", body: settings) { (json, error) -> Void in
            guard let json = json else {
                completion?(user: nil, error: error)
                return
            }
            
            let user = BeamUser(json: json)
            completion?(user: user, error: error)
        }
    }
    
    // MARK: Retrieving User Data
    
    public func getFollowedChannelsByUser(id: Int, completion: ((channels: [BeamChannel]?, error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/users/\(id)/follows", requestType: "GET") { (json, error) -> Void in
            guard let json = json,
                channels = json.array else {
                    completion?(channels: nil, error: error)
                    return
            }
            
            var retrievedChannels = [BeamChannel]()
            
            for channel in channels {
                let retrievedChannel = BeamChannel(json: channel)
                retrievedChannels.append(retrievedChannel)
            }
            
            completion?(channels: retrievedChannels, error: error)
        }
    }
    
    public func getPreferences(id: Int, completion: ((preferences: [String: AnyObject]?, error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/users/\(id)/preferences", requestType: "GET") { (json, error) -> Void in
            guard let json = json,
                preferences = json.dictionaryObject else {
                    completion?(preferences: nil, error: error)
                    return
            }
            
            completion?(preferences: preferences, error: error)
        }
    }
    
    // MARK: Retrieving Users
    
    public func getUserWithId(id: Int, completion: ((user: BeamUser?, error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/users/\(id)", requestType: "GET") { (json, error) -> Void in
            guard let json = json else {
                completion?(user: nil, error: error)
                return
            }
            
            let user = BeamUser(json: json)
            completion?(user: user, error: error)
        }
    }
    
    public func getUsersByQuery(query: String, completion: ((users: [BeamUser]?, error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/users/search", requestType: "GET") { (json, error) -> Void in
            guard let json = json,
                let users = json.array else {
                    completion?(users: nil, error: error)
                    return
            }
            
            var retrievedUsers = [BeamUser]()
            
            for user in users {
                let retrievedUser = BeamUser(json: user)
                retrievedUsers.append(retrievedUser)
            }
            
            completion?(users: retrievedUsers, error: error)
        }
    }
}
