//
//  UsersRoutes.swift
//  Beam
//
//  Created by Jack Cook on 1/8/16.
//  Copyright © 2016 MCProHosting. All rights reserved.
//

public class UsersRoutes {
    
    // MARK: Acting on User Data
    
    public func forgotPassword(email: String, completion: (error: BeamRequestError?) -> Void) {
        BeamRequest.request("/users/reset", requestType: "POST", body: "email=\(email)") { (json, error) -> Void in
            guard error == nil else {
                completion(error: error)
                return
            }
            
            completion(error: nil)
        }
    }
    
    // MARK: Retrieving User Data
    
    public func getFollowedChannelsByUser(id: Int, completion: (channels: [BeamChannel]?, error: BeamRequestError?) -> Void) {
        BeamRequest.request("/users/\(id)/follows", requestType: "GET") { (json, error) -> Void in
            guard let json = json,
                channels = json.array else {
                    completion(channels: nil, error: error)
                    return
            }
            
            var retrievedChannels = [BeamChannel]()
            
            for channel in channels {
                let retrievedChannel = BeamChannel(json: channel)
                retrievedChannels.append(retrievedChannel)
            }
            
            completion(channels: retrievedChannels, error: error)
        }
    }
    
    // MARK: Retrieving Users
    
    public func getUserWithId(id: Int, completion: (user: BeamUser?, error: BeamRequestError?) -> Void) {
        BeamRequest.request("/users/\(id)", requestType: "GET") { (json, error) -> Void in
            guard let json = json else {
                completion(user: nil, error: error)
                return
            }
            
            let user = BeamUser(json: json)
            completion(user: user, error: error)
        }
    }
    
    public func getUsersByQuery(query: String, completion: (users: [BeamUser]?, error: BeamRequestError?) -> Void) {
        BeamRequest.request("/users/search", requestType: "GET") { (json, error) -> Void in
            guard let json = json,
                let users = json.array else {
                    completion(users: nil, error: error)
                    return
            }
            
            var retrievedUsers = [BeamUser]()
            
            for user in users {
                let retrievedUser = BeamUser(json: user)
                retrievedUsers.append(retrievedUser)
            }
            
            completion(users: retrievedUsers, error: error)
        }
    }
}
