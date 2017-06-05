//
//  MixerChannel.swift
//  Mixer API
//
//  Created by Jack Cook on 4/25/15.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//

import SwiftyJSON

/// A channel object.
public struct MixerChannel {
    
    /// The channel's identifier.
    public let id: Int
    
    /// The identifier of the channel's user.
    public let userId: Int
    
    /// The channel's token/username.
    public let token: String
    
    /// True if the channel is online.
    public let online: Bool
    
    /// True if the channel is featured by Mixer.
    public let featured: Bool
    
    /// True if the channel is partnered with Mixer.
    public let partnered: Bool
    
    /// True if the channel has transcoding enabled.
    public let transcodingEnabled: Bool
    
    /// True if the channel is suspended.
    public let suspended: Bool
    
    /// The name of the channel's stream.
    public let name: String
    
    /// A short description of the recommended audience (e.g. teen)
    public let audience: String
    
    /// The total number of viewers the channel has ever had.
    public let viewersTotal: Int
    
    /// The current number of viewers watching the channel.
    public let viewersCurrent: Int
    
    /// The channel's number of followers.
    public let followers: Int
    
    /// A description filled out by the channel owner.
    public let desc: String?
    
    /// The id of the game being played by the channel.
    public let typeId: Int?
    
    /// True if the channel's content is interactive.
    public let interactive: Bool
    
    /// The id of the interactive game being used by the channel.
    public let interactiveGameId: Int?
    
    /// FTL is enabled if this value is > 0.
    public let ftl: Int
    
    /// True if the channel has a stored video on demand.
    public let hasVod: Bool
    
    /// The date, in UTC, on which the channel was created.
    public let createdAt: Date?
    
    /// The date, in UTC, on which channel was last updated.
    public let updatedAt: Date?
    
    /// The number of subscribers to the channel. nil if this is not the authenticated user's channel.
    public let subscribers: Int?
    
    /// The channel's thumbnail.
    public let thumbnail: MixerThumbnail?
    
    /// The game being played by the channel.
    public let type: MixerType?
    
    /// The text set by the channel owner that should be used if the stream is shared.
    public var shareText: String?
    
    /// A short description of the channel's costream setting (e.g all)
    public var costreamAllow: String?
    
    /// True if links in the channel's chat should be clickable.
    public var linksClickable: Bool?
    
    /// True if links are allowed in the channel's chat.
    public var linksAllowed: Bool?
    
    /// The number of seconds between which messages can be sent by a non-moderating user.
    public var slowChat: Int?
    
    /// The message displayed in chat when a user follows the channel.
    public var followMessage: String?
    
    /// The message displayed in chat when a user subscribes to the channel.
    public var subscribeMessage: String?
    
    /// The message displayed in chat when the authenticated user subscribes to the channel.
    public var submail: String?
    
    /// The channel's user object.
    public let user: MixerUser?
    
    /// An object containing data about the relationship between an authenticated user and the channel.
    fileprivate let status: [String: JSON]?
    
    /// True if the authenticated user is following the channel.
    public var following: Bool? {
        get {
            if let follows = status?["follows"] {
                return follows.dictionary != nil
            }
            
            return false
        }
    }
    
    /// The roles that the authenticated user has in the channel.
    public var roles: [MixerGroup]? {
        get {
            if let roles = status?["roles"], let rolesArray = roles.array {
                var retrievedRoles = [MixerGroup]()
                
                for role in rolesArray {
                    if let roleString = role.string, let group = MixerGroup(rawValue: roleString) {
                        retrievedRoles.append(group)
                    }
                }
                
                return retrievedRoles
            }
            
            return nil
        }
    }
    
    /// Used to initialize a channel given JSON data.
    init(json: JSON) {
        id = json["id"].int ?? 0
        userId = json["userId"].int ?? 0
        token = json["token"].string ?? ""
        online = json["online"].bool ?? ((json["online"].int ?? 0) == 1)
        featured = json["featured"].bool ?? ((json["featured"].int ?? 0) == 1)
        partnered = json["partnered"].bool ?? ((json["partnered"].int ?? 0) == 1)
        transcodingEnabled = json["transcodingEnabled"].bool ?? ((json["transcodingEnabled"].int ?? 0) == 1)
        suspended = json["suspended"].bool ?? ((json["suspended"].int ?? 0) == 1)
        name = json["name"].string ?? ""
        audience = json["audience"].string ?? ""
        viewersTotal = json["viewersTotal"].int ?? 0
        viewersCurrent = json["viewersCurrent"].int ?? 0
        followers = json["numFollowers"].int ?? 0
        desc = json["description"].string
        typeId = json["typeId"].int
        interactive = json["interactive"].bool ?? ((json["interactive"].int ?? 0) == 1)
        interactiveGameId = json["tetrisGameId"].int
        ftl = json["ftl"].int ?? 0
        hasVod = json["hasVod"].bool ?? false
        createdAt = Date.fromMixer(json["createdAt"].string)
        updatedAt = Date.fromMixer(json["updatedAt"].string)
        subscribers = json["numSubscribers"].int
        
        thumbnail = MixerThumbnail(json: json["thumbnail"])
        type = MixerType(json: json["type"])
        
        if let preferences = json["preferences"].dictionary {
            costreamAllow = preferences["costream:allow"]?.string
            shareText = preferences["sharetext"]?.string
            linksClickable = preferences["channel:links:clickable"]?.bool
            linksAllowed = preferences["channel:links:allowed"]?.bool
            slowChat = preferences["channel:slowchat"]?.int
            subscribeMessage = preferences["channel:notify:subscribemessage"]?.string
            followMessage = preferences["channel:notify:followmessage"]?.string
            submail = preferences["channel:partner:submail"]?.string
        }
        
        user = json["user"].dictionary == nil ? nil : MixerUser(json: json["user"])
        status = json["status"].dictionary
    }
}
