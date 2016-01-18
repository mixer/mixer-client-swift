//
//  ChannelsRoutes.swift
//  Beam
//
//  Created by Jack Cook on 1/8/16.
//  Copyright © 2016 MCProHosting. All rights reserved.
//

public class ChannelsRoutes {
    
    // MARK: Acting on Channels
    
    public func followChannel(channelId: Int, completion: (error: BeamRequestError?) -> Void) {
        guard let session = BeamSession.sharedSession else {
            completion(error: .NotAuthenticated)
            return
        }
        
        BeamRequest.request("/channels/\(channelId)/follow", requestType: "PUT", body: "{\"user\": \"\(session.user.id)\"}") { (json, error) -> Void in
            completion(error: error)
        }
    }
    
    public func unfollowChannel(channelId: Int, completion: (error: BeamRequestError?) -> Void) {
        guard let session = BeamSession.sharedSession else {
            completion(error: .NotAuthenticated)
            return
        }
        
        BeamRequest.request("/channels/\(channelId)/follow", requestType: "DELETE", body: "{\"user\": \"\(session.user.id)\"}") { (json, error) -> Void in
            completion(error: error)
        }
    }
    
    public func banUser(channelId: Int, userId: Int, completion: (error: BeamRequestError?) -> Void) {
        updateUserRoles(channelId, userId: userId, requestBody: "{\"add\": [\"Banned\"]}", completion: completion)
    }
    
    public func unbanUser(channelId: Int, userId: Int, completion: (error: BeamRequestError?) -> Void) {
        updateUserRoles(channelId, userId: userId, requestBody: "{\"remove\": [\"Banned\"]}", completion: completion)
    }
    
    public func updateUserRoles(channelId: Int, userId: Int, requestBody: String, completion: (error: BeamRequestError?) -> Void) {
        guard let _ = BeamSession.sharedSession else {
            completion(error: .NotAuthenticated)
            return
        }
        
        BeamRequest.request("/channels/\(channelId)/users/\(userId)", requestType: "PATCH", body: requestBody) { (json, error) -> Void in
            completion(error: error)
        }
    }
    
    
    
    // MARK: Retrieving Channels
    
    public func getChannelWithId(id: Int, completion: (channel: BeamChannel?, error: BeamRequestError?) -> Void) {
        self.getChannelWithEndpoint(String(id), completion: completion)
    }
    
    public func getChannelWithToken(token: String, completion: (channel: BeamChannel?, error: BeamRequestError?) -> Void) {
        self.getChannelWithEndpoint(token, completion: completion)
    }
    
    private func getChannelWithEndpoint(endpoint: String, completion: (channel: BeamChannel?, error: BeamRequestError?) -> Void) {
        BeamRequest.request("/channels/\(endpoint)", requestType: "GET") { (json, error) -> Void in
            guard let json = json else {
                completion(channel: nil, error: error)
                return
            }
            
            let channel = BeamChannel(json: json)
            completion(channel: channel, error: error)
        }
    }
    
    public func getDefaultChannels(completion: (channels: [BeamChannel]?, error: BeamRequestError?) -> Void) {
        BeamRequest.request("/channels", requestType: "GET") { (json, error) -> Void in
            guard let json = json,
                let channels = json.array else {
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
    
    public func getChannelsByQuery(query: String, completion: (channels: [BeamChannel]?, error: BeamRequestError?) -> Void) {
        BeamRequest.request("/channels", requestType: "GET", params: ["scope": "all", "sort": "viewers_total:asc", "q": query]) { (json, error) -> Void in
            guard let json = json,
                let channels = json.array else {
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
    
    public func getChannelsByType(typeId: Int, completion: (channels: [BeamChannel]?, error: BeamRequestError?) -> Void) {
        // where=online.neq.0 should not be used, combine with getChannelsWithQuery when the "sort" parameter works with this request
        BeamRequest.request("/types/\(typeId)/channels", requestType: "GET", params: ["where": "online.neq.0"]) { (json, error) -> Void in
            guard let json = json,
                let channels = json.array else {
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
    
    public func getTypes(completion: (types: [BeamType]?, error: BeamRequestError?) -> Void) {
        BeamRequest.request("/types", requestType: "GET", params: ["where": "online.neq.0"]) { (json, error) -> Void in
            guard let json = json,
                types = json.array else {
                    completion(types: nil, error: error)
                    return
            }
            
            var retrievedTypes = [BeamType]()
            
            for type in types {
                let retrievedType = BeamType(json: type)
                retrievedTypes.append(retrievedType)
            }
            
            completion(types: retrievedTypes, error: error)
        }
    }
}
