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
    public func forgotPassword(_ email: String, completion: ((_ error: BeamRequestError?) -> Void)?) {
        let body = ["email": email]
        
        BeamRequest.request("/users/reset", requestType: "POST", body: body) { (json, error) in
            completion?(error: error)
        }
    }
    
    /**
     Updates a user's preferences.
     
     :param: id The id of the user whose preferences are being updated.
     :param: preferences The preference data string to be interpreted by Beam's servers.
     :param: completion An optional completion block that fires when the preferences have been updated.
     */
    public func updatePreferences(_ id: Int, preferences: AnyObject, completion: ((_ error: BeamRequestError?) -> Void)?) {
        guard let _ = BeamSession.sharedSession else {
            completion?(.notAuthenticated)
            return
        }
        
        BeamRequest.request("/users/\(id)/preferences", requestType: "POST", body: preferences) { (json, error) in
            completion?(error: error)
        }
    }
    
    /**
     Updates a user's profile.
     
     :param: id The id of the user whose profile is being updated.
     :param: settings The string of profile data to be interpreted by the Beam servers.
     :param: completion An optional completion block that fires when the profile has been updated.
     */
    public func updateProfile(_ id: Int, settings: AnyObject, completion: ((_ user: BeamUser?, _ error: BeamRequestError?) -> Void)?) {
        guard let _ = BeamSession.sharedSession else {
            completion?(nil, .notAuthenticated)
            return
        }
        
        BeamRequest.request("/users/\(id)", requestType: "PUT", body: settings) { (json, error) in
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
     Retrieves all achievements that have been earned by a user.
     
     :param: userId The id of the user whose achievements are being retrieved.
     :param: completion An optional completion block with retrieved achievement data.
     */
    public func getAchievementsByUser(_ userId: Int, completion: ((_ achievements: [BeamUserAchievement]?, _ error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/users/\(userId)/achievements") { (json, error) in
            guard let achievements = json?.array else {
                completion?(achievements: nil, error: error)
                return
            }
            
            var retrievedAchievements = [BeamUserAchievement]()
            
            for achievement in achievements {
                let retrievedAchievement = BeamUserAchievement(json: achievement)
                retrievedAchievements.append(retrievedAchievement)
            }
            
            completion?(achievements: retrievedAchievements, error: error)
        }
    }
    
    /**
     Retrieves the channels that a given user is following.
    
     :param: id The id of the user whose followed channels are being retrieved.
     :param: completion An optional completion block with retrieved channels' data.
     */
    public func getFollowedChannelsByUser(_ id: Int, page: Int, completion: ((_ channels: [BeamChannel]?, _ error: BeamRequestError?) -> Void)?) {
        let params = ["order": "online:desc,viewersCurrent:desc,viewersTotal:desc", "where": "suspended.eq.0", "page": "\(page)"]
        
        BeamRequest.request("/users/\(id)/follows", params: params) { (json, error) in
            guard let channels = json?.array else {
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
    public func getPreferences(_ id: Int, completion: ((_ preferences: [String: AnyObject]?, _ error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/users/\(id)/preferences") { (json, error) in
            guard let preferences = json?.dictionaryObject else {
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
    public func getUserWithId(_ id: Int, completion: ((_ user: BeamUser?, _ error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/users/\(id)") { (json, error) in
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
    public func getUsersByQuery(_ query: String, completion: ((_ users: [BeamUser]?, _ error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/users/search") { (json, error) in
            guard let users = json?.array else {
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
