//
//  ChannelsRoutes.swift
//  Beam
//
//  Created by Jack Cook on 1/8/16.
//  Copyright © 2016 MCProHosting. All rights reserved.
//

/// Routes that can be used to interact with and retrieve channel data.
public class ChannelsRoutes {
    
    // MARK: Acting on Channels
    
    /**
     Follows a channel if there is an authenticated user.
    
     :param: channelId The id of the channel being followed.
     :param: completion An optional completion block that fires when the follow has been completed.
     */
    public func followChannel(channelId: Int, completion: ((error: BeamRequestError?) -> Void)?) {
        guard let session = BeamSession.sharedSession else {
            completion?(error: .NotAuthenticated)
            return
        }
        
        BeamRequest.request("/channels/\(channelId)/follow", requestType: "PUT", body: "{\"user\": \"\(session.user.id)\"}") { (json, error) -> Void in
            completion?(error: error)
        }
    }
    
    /**
     Unfollows a channel if there is an authenticated user.
     
     :param: channelId The id of the channel being unfollowed.
     :param: completion An optional completion block that fires when the unfollow has been completed.
     */
    public func unfollowChannel(channelId: Int, completion: ((error: BeamRequestError?) -> Void)?) {
        guard let session = BeamSession.sharedSession else {
            completion?(error: .NotAuthenticated)
            return
        }
        
        BeamRequest.request("/channels/\(channelId)/follow", requestType: "DELETE", body: "{\"user\": \"\(session.user.id)\"}") { (json, error) -> Void in
            completion?(error: error)
        }
    }
    
    /**
     Bans a user from watching and chatting in a channel.
     
     :param: channelId The id of the channel that the user is being banned from.
     :param: userId The id of the user who is being banned.
     :param: completion An optional completion block that fires when the ban has been completed.
     */
    public func banUser(channelId: Int, userId: Int, completion: ((error: BeamRequestError?) -> Void)?) {
        updateUserRoles(channelId, userId: userId, requestBody: "{\"add\": [\"Banned\"]}", completion: completion)
    }
    
    /**
     Unbans a user from watching and chatting in a channel.
     
     :param: channelId The id of the channel that the user is being unbanned from.
     :param: userId The id of the user who is being unbanned.
     :param: completion An optional completion block that fires when the unban has been completed.
     */
    public func unbanUser(channelId: Int, userId: Int, completion: ((error: BeamRequestError?) -> Void)?) {
        updateUserRoles(channelId, userId: userId, requestBody: "{\"remove\": [\"Banned\"]}", completion: completion)
    }
    
    /**
     Updates a user's roles in a channel.
     
     :param: channelId The id of the channel that the user is being updated in.
     :param: userId The id of the user whose roles are being updated.
     :param: completion An optional completion block that fires when the update has been completed.
     */
    public func updateUserRoles(channelId: Int, userId: Int, requestBody: String, completion: ((error: BeamRequestError?) -> Void)?) {
        guard let _ = BeamSession.sharedSession else {
            completion?(error: .NotAuthenticated)
            return
        }
        
        BeamRequest.request("/channels/\(channelId)/users/\(userId)", requestType: "PATCH", body: requestBody) { (json, error) -> Void in
            completion?(error: error)
        }
    }
    
    // MARK: Retrieving Channels
    
    /**
     Retrieves a channel with the specified identifier.
    
     :param: id The identifier of the channel being retrieved.
     :param: completion An optional completion block with retrieved channel data.
     */
    public func getChannelWithId(id: Int, completion: ((channel: BeamChannel?, error: BeamRequestError?) -> Void)?) {
        self.getChannelWithEndpoint(String(id), completion: completion)
    }
    
    /**
     Retrieves a channel with the specified token.
     
     :param: token The token of the channel being retrieved.
     :param: completion An optional completion block with retrieved channel data.
     */
    public func getChannelWithToken(token: String, completion: ((channel: BeamChannel?, error: BeamRequestError?) -> Void)?) {
        self.getChannelWithEndpoint(token, completion: completion)
    }
    
    /**
     Retrieves a channel from the specified endpoint.
     
     :param: endpoint The endpoint that the channel is being retrieved from.
     :param: completion An optional completion block with retrieved channel data.
     */
    private func getChannelWithEndpoint(endpoint: String, completion: ((channel: BeamChannel?, error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/channels/\(endpoint)", requestType: "GET") { (json, error) -> Void in
            guard let json = json else {
                completion?(channel: nil, error: error)
                return
            }
            
            let channel = BeamChannel(json: json)
            completion?(channel: channel, error: error)
        }
    }
    
    /**
     Retrieves channels to be browsed with default parameters.
     
     :param: completion An optional completion block with the retrieved channels' data.
     */
    public func getDefaultChannels(completion: ((channels: [BeamChannel]?, error: BeamRequestError?) -> Void)?) {
        getChannelsByEndpoint("/channels", params: nil, completion: completion)
    }
    
    /**
     Retrieves channels to be browsed with default parameters and pagination.
     
     :param: completion An optional completion block with the retrieved channels' data.
     */
    public func getDefaultChannels(offset: Int, completion: ((channels: [BeamChannel]?, error: BeamRequestError?) -> Void)?) {
        let params = ["order": "online:desc,viewersCurrent:desc,viewersTotal:desc", "where": "suspended.eq.0", "page": "\(offset / 50)"]
        getChannelsByEndpoint("/channels", params: params, completion: completion)
    }
    
    /**
     Searches for channels with a specified query.
     
     :param: query The query being used to search for channels.
     :param: completion An optional completion block with the retrieved channels' data.
     */
    public func getChannelsByQuery(query: String, completion: ((channels: [BeamChannel]?, error: BeamRequestError?) -> Void)?) {
        getChannelsByEndpoint("/channels", params: ["scope": "all", "sort": "viewers_total:asc", "q": query], completion: completion)
    }
    
    /**
     Retrieves channels currently playing a given game.
     
     :param: typeId The identifier of the type being played.
     :param: completion An optional completion block with the retrieved channels' data.
     */
    public func getChannelsByType(typeId: Int, completion: ((channels: [BeamChannel]?, error: BeamRequestError?) -> Void)?) {
        getChannelsByEndpoint("/types/\(typeId)/channels", params: nil, completion: completion)
    }
    
    /**
     Retrieves channels from a specified endpoint.
     
     :param: endpoint The endpoint that the channels are being retrieved from.
     :param: params An optional set of parameters to be applied to the request.
     :param: completion An optional completion block with the retrieved channels' data.
     */
    private func getChannelsByEndpoint(endpoint: String, params: [String: String]?, completion: ((channels: [BeamChannel]?, error: BeamRequestError?) -> Void)?) {
        let defaultParams = ["order": "online:desc,viewersCurrent:desc,viewersTotal:desc", "where": "suspended.eq.0"]
        BeamRequest.request(endpoint, requestType: "GET", params: params ?? defaultParams) { (json, error) -> Void in
            guard let json = json,
                let channels = json.array else {
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
     Retrieves games that are being played by at least one channel.
     
     :param: completion An optional completion block with the retrieved channels' data.
     */
    public func getTypes(completion: ((types: [BeamType]?, error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/types", requestType: "GET", params: ["where": "online.neq.0"]) { (json, error) -> Void in
            guard let json = json,
                types = json.array else {
                    completion?(types: nil, error: error)
                    return
            }
            
            var retrievedTypes = [BeamType]()
            
            for type in types {
                let retrievedType = BeamType(json: type)
                retrievedTypes.append(retrievedType)
            }
            
            completion?(types: retrievedTypes, error: error)
        }
    }
}
