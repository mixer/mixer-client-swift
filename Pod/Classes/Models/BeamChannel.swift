//
//  BeamChannel.swift
//  Beam API
//
//  Created by Jack Cook on 4/25/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import SwiftyJSON

public struct BeamChannel {
    
    public let id: Int
    public let token: String
    public let online: Bool
    public let featured: Bool
    public let partnered: Bool
    public let transcodingEnabled: Bool
    public let suspended: Bool
    public let name: String
    public let audience: String
    public let viewersTotal: Int
    public let viewersCurrent: Int
    public let followers: Int
    public let desc: String?
    public let typeId: Int?
    public let interactive: Bool
    public let ftl: Int
    public let subscribers: Int?
    public let userId: Int?
    public let thumbnail: BeamThumbnail?
    public let type: BeamType?
    
    public var shareText: String?
    public var costreamAllow: String?
    public var linksClickable: Bool?
    public var linksAllowed: Bool?
    public var slowChat: Int?
    public var followMessage: String?
    public var subscribeMessage: String? // message that appears when other users subscribe
    public var submail: String? // message that appears when the current user subscribes
    
    public let user: BeamUser?
    public let cache: [BeamMessage]?
    
    private let status: [String: JSON]?
    public var following: Bool? {
        get {
            if let follows = status?["follows"] {
                return follows.dictionary != nil
            }
            
            return false
        }
    }
    
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
    
    public init(json: JSON) {
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
        
        cache = [BeamMessage]()
        if let cache = json["cache"].array {
            for message in cache {
                let msg = BeamMessage(json: message)
                self.cache!.append(msg)
            }
        }
        
        status = json["status"].dictionary
    }
}
