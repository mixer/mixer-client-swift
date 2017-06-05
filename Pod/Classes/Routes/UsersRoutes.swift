//
//  UsersRoutes.swift
//  Mixer
//
//  Created by Jack Cook on 1/8/16.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
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
    public func forgotPassword(_ email: String, completion: ((_ error: MixerRequestError?) -> Void)?) {
        let body = ["email": email] as AnyObject
        
        MixerRequest.request("/users/reset", requestType: "POST", body: body, options: .mayNeedCSRF) { (json, error) in
            completion?(error)
        }
    }
    
    /**
     Updates a user's preferences.
     
     :param: id The id of the user whose preferences are being updated.
     :param: preferences The preference data string to be interpreted by Mixer's servers.
     :param: completion An optional completion block that fires when the preferences have been updated.
     */
    public func updatePreferences(_ id: Int, preferences: AnyObject, completion: ((_ error: MixerRequestError?) -> Void)?) {
        guard let _ = MixerSession.sharedSession else {
            completion?(.notAuthenticated)
            return
        }
        
        MixerRequest.request("/users/\(id)/preferences", requestType: "POST", body: preferences) { (json, error) in
            completion?(error)
        }
    }
    
    /**
     Updates a user's profile.
     
     :param: id The id of the user whose profile is being updated.
     :param: settings The string of profile data to be interpreted by the Mixer servers.
     :param: completion An optional completion block that fires when the profile has been updated.
     */
    public func updateProfile(_ id: Int, settings: AnyObject, completion: ((_ user: MixerUser?, _ error: MixerRequestError?) -> Void)?) {
        guard let _ = MixerSession.sharedSession else {
            completion?(nil, .notAuthenticated)
            return
        }
        
        MixerRequest.request("/users/\(id)", requestType: "PUT", body: settings) { (json, error) in
            guard let json = json else {
                completion?(nil, error)
                return
            }
            
            let user = MixerUser(json: json)
            completion?(user, error)
        }
    }
    
    // MARK: Retrieving User Data
    
    /**
     Retrieves all achievements that have been earned by a user.
     
     :param: userId The id of the user whose achievements are being retrieved.
     :param: completion An optional completion block with retrieved achievement data.
     */
    public func getAchievementsByUser(_ userId: Int, completion: ((_ achievements: [MixerUserAchievement]?, _ error: MixerRequestError?) -> Void)?) {
        MixerRequest.request("/users/\(userId)/achievements") { (json, error) in
            guard let achievements = json?.array else {
                completion?(nil, error)
                return
            }
            
            var retrievedAchievements = [MixerUserAchievement]()
            
            for achievement in achievements {
                let retrievedAchievement = MixerUserAchievement(json: achievement)
                retrievedAchievements.append(retrievedAchievement)
            }
            
            completion?(retrievedAchievements, error)
        }
    }
    
    /**
     Retrieves the channels that a given user is following.
    
     :param: id The id of the user whose followed channels are being retrieved.
     :param: completion An optional completion block with retrieved channels' data.
     */
    public func getFollowedChannelsByUser(_ id: Int, page: Int, completion: ((_ channels: [MixerChannel]?, _ error: MixerRequestError?) -> Void)?) {
        let params = [
            "order": "online:desc,viewersCurrent:desc,viewersTotal:desc",
            "where": "suspended.eq.0",
            "page": "\(page)",
            "noCount": "1",
        ]
        
        MixerRequest.request("/users/\(id)/follows", params: params) { (json, error) in
            guard let channels = json?.array else {
                completion?(nil, error)
                return
            }
            
            var retrievedChannels = [MixerChannel]()
            
            for channel in channels {
                let retrievedChannel = MixerChannel(json: channel)
                retrievedChannels.append(retrievedChannel)
            }
            
            completion?(retrievedChannels, error)
        }
    }
    
    /**
     Retrieves a user's preferences.
     
     :param: id The id of the user whose preferences are being retrieved.
     :param: completion An optional completion block with retrieved preferences data.
     */
    public func getPreferences(_ id: Int, completion: ((_ preferences: [String: AnyObject]?, _ error: MixerRequestError?) -> Void)?) {
        MixerRequest.request("/users/\(id)/preferences") { (json, error) in
            guard let preferences = json?.dictionaryObject as? [String: AnyObject] else {
                completion?(nil, error)
                return
            }
            
            completion?(preferences, error)
        }
    }
    
    // MARK: Retrieving Users
    
    /**
     Retrieves a user with the specified identifer.
    
     :param: id The identifier of the user being retrieved.
     :param: completion An optional completion block with retrieved user data.
     */
    public func getUserWithId(_ id: Int, completion: ((_ user: MixerUser?, _ error: MixerRequestError?) -> Void)?) {
        MixerRequest.request("/users/\(id)") { (json, error) in
            guard let json = json else {
                completion?(nil, error)
                return
            }
            
            let user = MixerUser(json: json)
            completion?(user, error)
        }
    }
    
    /**
     Retrieves users who match a given query.
     
     :param: query The search/query to be performed to find users.
     :param: completion An optional completion block with the retrieved users' data.
     */
    public func getUsersByQuery(_ query: String, completion: ((_ users: [MixerUser]?, _ error: MixerRequestError?) -> Void)?) {
        MixerRequest.request("/users/search") { (json, error) in
            guard let users = json?.array else {
                completion?(nil, error)
                return
            }
            
            var retrievedUsers = [MixerUser]()
            
            for user in users {
                let retrievedUser = MixerUser(json: user)
                retrievedUsers.append(retrievedUser)
            }
            
            completion?(retrievedUsers, error)
        }
    }
}
