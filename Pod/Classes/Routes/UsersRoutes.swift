//
//  UsersRoutes.swift
//  Beam
//
//  Created by Jack Cook on 1/8/16.
//  Copyright © 2016 MCProHosting. All rights reserved.
//

import SwiftyJSON

/// Routes that can be used to interact with and retrieve user data.
public class UsersRoutes {
    
    // MARK: Acting on User Data
    
    /**
     Triggers an email to be sent about a user's forgotten password.
    
     :param: email The email address of the user whose password was forgotten.
     :param: completion An optional completion block that fires when the email has been sent.
     */
    public func forgotPassword(email: String, completion: ((error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/users/reset", requestType: "POST", body: "email=\(email)") { (json, error) -> Void in
            completion?(error: error)
        }
    }
    
    /**
     Updates a user's preferences.
     
     :param: id The id of the user whose preferences are being updated.
     :param: preferences The preference data string to be interpreted by Beam's servers.
     :param: completion An optional completion block that fires when the preferences have been updated.
     */
    public func updatePreferences(id: Int, preferences: String, completion: ((error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/users/\(id)/preferences", requestType: "POST", body: preferences) { (json, error) -> Void in
            completion?(error: error)
        }
    }
    
    /**
     Updates a user's push notification preferences.
     
     :param: id The id of the user whose notification preferences are being updated.
     :param: enable True if push notifications should be enabled.
     :param: completion An optional completion block that fires when the preference has been updated.
     */
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
    
    /**
     Updates a user's profile.
     
     :param: id The id of the user whose profile is being updated.
     :param: settings The string of profile data to be interpreted by the Beam servers.
     :param: completion An optional completion block that fires when the profile has been updated.
     */
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
    
    /**
     Retrieves the channels that a given user is following.
    
     :param: id The id of the user whose followed channels are being retrieved.
     :param: completion An optional completion block with retrieved channels' data.
     */
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
    
    /**
     Retrieves a user's preferences.
     
     :param: id The id of the user whose preferences are being retrieved.
     :param: completion An optional completion block with retrieved preferences data.
     */
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
    
    /**
     Retrieves a user with the specified identifer.
    
     :param: id The identifier of the user being retrieved.
     :param: completion An optional completion block with retrieved user data.
     */
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
    
    /**
     Retrieves users who match a given query.
     
     :param: query The search/query to be performed to find users.
     :param: completion An optional completion block with the retrieved users' data.
     */
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
