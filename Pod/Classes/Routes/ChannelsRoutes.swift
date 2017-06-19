//
//  ChannelsRoutes.swift
//  Mixer
//
//  Created by Jack Cook on 1/8/16.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//

import SwiftyJSON

/// Routes that can be used to interact with and retrieve channel data.
public class ChannelsRoutes {
    
    /// The type of channels being requested.
    public enum ChannelsRequestType {
        case all, interactive, rising, fresh
    }
    
    // MARK: Acting on Channels
    
    /**
     Follows a channel if there is an authenticated user.
    
     :param: channelId The id of the channel being followed.
     :param: completion An optional completion block that fires when the follow has been completed.
     */
    public func followChannel(_ channelId: Int, completion: ((_ error: MixerRequestError?) -> Void)?) {
        guard let session = MixerSession.sharedSession else {
            completion?(.notAuthenticated)
            return
        }
        
        let body = ["user": String(session.user.id)] as AnyObject
        
        MixerRequest.request("/channels/\(channelId)/follow", requestType: "PUT", body: body) { (json, error) in
            completion?(error)
        }
    }
    
    /**
     Unfollows a channel if there is an authenticated user.
     
     :param: channelId The id of the channel being unfollowed.
     :param: completion An optional completion block that fires when the unfollow has been completed.
     */
    public func unfollowChannel(_ channelId: Int, completion: ((_ error: MixerRequestError?) -> Void)?) {
        guard let session = MixerSession.sharedSession else {
            completion?(.notAuthenticated)
            return
        }
        
        let body = ["user": String(session.user.id)] as AnyObject
        
        MixerRequest.request("/channels/\(channelId)/follow", requestType: "DELETE", body: body) { (json, error) in
            completion?(error)
        }
    }
    
    /**
     Bans a user from watching and chatting in a channel.
     
     :param: channelId The id of the channel that the user is being banned from.
     :param: userId The id of the user who is being banned.
     :param: completion An optional completion block that fires when the ban has been completed.
     */
    public func banUser(_ channelId: Int, userId: Int, completion: ((_ error: MixerRequestError?) -> Void)?) {
        let body = ["add": ["Banned"]]
        
        updateUserRoles(channelId, userId: userId, requestBody: body as AnyObject, completion: completion)
    }
    
    /**
     Unbans a user from watching and chatting in a channel.
     
     :param: channelId The id of the channel that the user is being unbanned from.
     :param: userId The id of the user who is being unbanned.
     :param: completion An optional completion block that fires when the unban has been completed.
     */
    public func unbanUser(_ channelId: Int, userId: Int, completion: ((_ error: MixerRequestError?) -> Void)?) {
        let body = ["remove": ["Banned"]]
        
        updateUserRoles(channelId, userId: userId, requestBody: body as AnyObject, completion: completion)
    }
    
    /**
     Updates a user's roles in a channel.
     
     :param: channelId The id of the channel that the user is being updated in.
     :param: userId The id of the user whose roles are being updated.
     :param: completion An optional completion block that fires when the update has been completed.
     */
    public func updateUserRoles(_ channelId: Int, userId: Int, requestBody: AnyObject, completion: ((_ error: MixerRequestError?) -> Void)?) {
        guard let _ = MixerSession.sharedSession else {
            completion?(.notAuthenticated)
            return
        }
        
        MixerRequest.request("/channels/\(channelId)/users/\(userId)", requestType: "PATCH", body: requestBody) { (json, error) in
            completion?(error)
        }
    }
    
    /**
     Hosts a channel from the currently authenticated user's channel.
     
     :param: channelId The id of the channel being hosted.
     :param: completion An optional completion block with response data.
     */
    public func hostChannel(_ channelId: Int, completion: ((_ error: MixerRequestError?) -> Void)?) {
        guard let id = MixerSession.sharedSession?.user.channel?.id else {
            completion?(.notAuthenticated)
            return
        }
        
        let body = ["id": channelId] as AnyObject
        
        MixerRequest.request("/channels/\(id)/hostee", requestType: "PUT", body: body) { (json, error) in
            completion?(error)
        }
    }
    
    /**
     Stops hosting a channel on the currently authenticated user's channel.
     
     :param: completion An optional completion block with response data.
     */
    public func stopHosting(_ completion: ((_ error: MixerRequestError?) -> Void)?) {
        guard let id = MixerSession.sharedSession?.user.channel?.id else {
            completion?(.notAuthenticated)
            return
        }
        
        MixerRequest.request("/channels/\(id)/hostee", requestType: "DELETE") { (json, error) in
            completion?(error)
        }
    }
    
    // MARK: Retrieving Channels
    
    /**
     Retrieves a channel with the specified identifier.
    
     :param: id The identifier of the channel being retrieved.
     :param: completion An optional completion block with retrieved channel data.
     */
    public func getChannelWithId(_ id: Int, completion: ((_ channel: MixerChannel?, _ error: MixerRequestError?) -> Void)?) {
        getChannelWithEndpoint("/channels/\(id)", completion: completion)
    }
    
    /**
     Retrieves a channel with the specified token.
     
     :param: token The token of the channel being retrieved.
     :param: completion An optional completion block with retrieved channel data.
     */
    public func getChannelWithToken(_ token: String, completion: ((_ channel: MixerChannel?, _ error: MixerRequestError?) -> Void)?) {
        getChannelWithEndpoint("/channels/\(token)", completion: completion)
    }
    
    /**
     Retrieves a channel from the specified endpoint.
     
     :param: endpoint The endpoint that the channel is being retrieved from.
     :param: completion An optional completion block with retrieved channel data.
     */
    fileprivate func getChannelWithEndpoint(_ endpoint: String, completion: ((_ channel: MixerChannel?, _ error: MixerRequestError?) -> Void)?) {
        MixerRequest.request(endpoint) { (json, error) in
            guard let json = json else {
                completion?(nil, error)
                return
            }
            
            let channel = MixerChannel(json: json)
            completion?(channel, error)
        }
    }
    
    /**
     Retrieves channels to be browsed with default parameters and pagination.
     
     :param: requestType The type of channels to be requested.
     :param: page The page of channels to be requested.
     :param: completion An optional completion block with the retrieved channels' data.
     */
    public func getChannels(_ requestType: ChannelsRequestType = .all, page: Int = 0, completion: ((_ channels: [MixerChannel]?, _ error: MixerRequestError?) -> Void)?) {
        var params = [
            "order": "viewersCurrent:desc",
            "where": "suspended.eq.0,online.eq.1",
            "page": "\(page)",
            "noCount": "1",
        ]
        
        switch requestType {
        case .interactive:
            params["where"] = "suspended.eq.0,online.eq.1,interactive.eq.1"
        case .rising:
            params["order"] = "online:desc,rising"
        case .fresh:
            params["order"] = "online:desc,fresh"
        default:
            break
        }
        
        getChannelsWithParameters(params, completion: completion)
    }
    
    /**
     Searches for channels with a specified query.
     
     :param: query The query being used to search for channels.
     :param: completion An optional completion block with the retrieved channels' data.
     */
    public func getChannelsByQuery(_ query: String, completion: ((_ channels: [MixerChannel]?, _ error: MixerRequestError?) -> Void)?) {
        getChannelsWithParameters([
            "scope": "all",
            "order": "viewersTotal:desc",
            "where": "suspended.eq.0",
            "q": query,
            "noCount": "1",
        ], completion: completion)
    }
    
    /**
     Retrieves channels from a specified endpoint.
     
     :param: params Parameters to be applied to the request.
     :param: completion An optional completion block with the retrieved channels' data.
     */
    fileprivate func getChannelsWithParameters(_ params: [String: String], completion: ((_ channels: [MixerChannel]?, _ error: MixerRequestError?) -> Void)?) {
        MixerRequest.request("/channels", requestType: "GET", params: params) { (json, error) in
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
    
    // MARK: Retrieving Channel Data
    
    /**
     Retrieves a channel's emoticons.
     
     :param: id The id of the channel followers are being retrieved from.
     :param: completion An optional completion block with the retrieved emoticons' data.
     */
    public func getEmoticonsOfChannel(_ id: Int, completion: ((_ spritesheetUrl: URL?, _ emoticons: [MixerEmoticon]?, _ error: MixerRequestError?) -> Void)?) {
        MixerRequest.request("/channels/\(id)/emoticons") { (json, error) in
            guard let json = json else {
                completion?(nil, nil, error)
                return
            }
            
            var spritesheet: URL?
            
            if let spritesheetUrl = json["url"].string {
                spritesheet = URL(string: spritesheetUrl)
            }
            
            var retrievedEmoticons: [MixerEmoticon]?
            
            if let emoticons = json["emoticons"].dictionary {
                retrievedEmoticons = [MixerEmoticon]()
                
                for (name, data) in emoticons {
                    let retrievedEmoticon = MixerEmoticon(name: name, json: data)
                    retrievedEmoticons?.append(retrievedEmoticon)
                }
            }
            
            completion?(spritesheet, retrievedEmoticons, error)
        }
    }
    
    /**
     Retrieves the followers of a channel, paginated.
     
     :param: id The id of the channel emoticons are being retrieved from.
     :param: page The page in the range [0, ∞] of followers being requested. Defaults to 0.
     :param: completion An optional copmletion block with the retrieved followers' data.
     */
    public func getFollowersOfChannel(_ id: Int, page: Int = 0, completion: ((_ users: [MixerUser]?, _ error: MixerRequestError?) -> Void)?) {
        MixerRequest.request("/channels/\(id)/follow", params: [
            "page": "\(page)",
            "noCount": "1",
        ]) { (json, error) in
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
    
    /**
     Retrieves the recordings of a channel.
     
     :param: channelId The id of the channel recordings are being retrieved from.
     :param: completion An optional completion block with the retrieved recordings' data.
     */
    public func getRecordingsOfChannel(_ id: Int, completion: ((_ recordings: [MixerRecording]?, _ error: MixerRequestError?) -> Void)?) {
        MixerRequest.request("/channels/\(id)/recordings", params: ["order": "createdAt:DESC"]) { (json, error) in
            guard let recordings = json?.array else {
                completion?(nil, error)
                return
            }
            
            var retrievedRecordings = [MixerRecording]()
            
            for recording in recordings {
                let retrievedRecording = MixerRecording(json: recording)
                retrievedRecordings.append(retrievedRecording)
            }
            
            completion?(retrievedRecordings, error)
        }
    }
    
    // MARK: Retrieving Emoticons
    
    /**
     Retrieves all default Mixer emoticon packs. Will eventually be removed by a new emoticon endpoint.
     
     :param: completion An optional completion block with the retrieved emoticon packs' data.
     */
    public func getDefaultEmoticons(_ completion: ((_ packs: [MixerEmoticonPack]?, _ error: MixerRequestError?) -> Void)?) {
        MixerRequest.dataRequest("https://mixer.com/_latest/emoticons/manifest.json") { (data, error) in
            guard let data = data, let packs = JSON(data: data).dictionary else {
                completion?(nil, error)
                return
            }
            
            var retrievedPacks = [MixerEmoticonPack]()
            
            for (slug, retrievedPack) in packs {
                let pack = MixerEmoticonPack(slug: slug, json: retrievedPack)
                retrievedPacks.append(pack)
            }
            
            completion?(retrievedPacks, error)
        }
    }
    
    // MARK: Updating Channels
    
    /**
     Updates data on a specified channel.
     
     :param: channelId The id of the channel being modified.
     :param: body The request body, containing the channel data to update.
     */
    public func updateData(_ channelId: Int, body: AnyObject, completion: ((_ channel: MixerChannel?, _ error: MixerRequestError?) -> Void)?) {
        guard let _ = MixerSession.sharedSession else {
            completion?(nil, .notAuthenticated)
            return
        }
        
        MixerRequest.request("/channels/\(channelId)", requestType: "PUT", body: body) { (json, error) in
            guard let json = json else {
                completion?(nil, error)
                return
            }
            
            let channel = MixerChannel(json: json)
            completion?(channel, error)
        }
    }
}
