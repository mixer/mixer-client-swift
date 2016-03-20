//
//  BeamChannel.swift
//  Beam API
//
//  Created by Jack Cook on 4/25/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import SwiftyJSON

/// A channel object.
public struct BeamChannel {
    
    /// The channel's identifier.
    public let id: Int
    
    /// The channel's token/username.
    public let token: String
    
    /// True if the channel is online.
    public let online: Bool
    
    /// True if the channel is featured by Beam.
    public let featured: Bool
    
    /// True if the channel is partnered with Beam.
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
    
    /// FTL is enabled if this value is > 0.
    public let ftl: Int
    
    /// The number of subscribers to the channel. nil if this is not the authenticated user's channel.
    public let subscribers: Int?
    
    /// The id of the channel's user.
    public let userId: Int?
    
    /// The channel's thumbnail.
    public let thumbnail: BeamThumbnail?
    
    /// The game being played by the channel.
    public let type: BeamType?
    
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
    public let user: BeamUser?
    
    /// An object containing data about the relationship between an authenticated user and the channel.
    private let status: [String: JSON]?
    
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
    public var roles: [BeamGroup]? {
        get {
            if let roles = status?["roles"],
                rolesArray = roles.array {
                    var retrievedRoles = [BeamGroup]()
                    
                    for role in rolesArray {
                        if let roleString = role.string,
                            group = BeamGroup(rawValue: roleString) {
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
        token = json["token"].string ?? ""
        online = json["online"].bool ?? (json["online"].int ?? 0) == 1
        featured = json["featured"].bool ?? (json["featured"].int ?? 0) == 1
        partnered = json["partnered"].bool ?? (json["partnered"].int ?? 0) == 1
        transcodingEnabled = json["transcodingEnabled"].bool ?? (json["transcodingEnabled"].int ?? 0) == 1
        suspended = json["suspended"].bool ?? (json["suspended"].int ?? 0) == 1
        name = json["name"].string ?? ""
        audience = json["audience"].string ?? ""
        viewersTotal = json["viewersTotal"].int ?? 0
        viewersCurrent = json["viewersCurrent"].int ?? 0
        followers = json["numFollowers"].int ?? 0
        desc = json["description"].string
        typeId = json["typeId"].int
        interactive = json["interactive"].bool ?? (json["interactive"].int ?? 0) == 1
        ftl = json["ftl"].int ?? 0
        subscribers = json["numSubscribers"].int
        userId = json["userId"].int
        
        thumbnail = BeamThumbnail(json: json["thumbnail"])
        type = BeamType(json: json["type"])
        
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
        
        user = json["user"].dictionary == nil ? nil : BeamUser(json: json["user"])
        status = json["status"].dictionary
    }
}
