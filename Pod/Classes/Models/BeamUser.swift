//
//  BeamUser.swift
//  Beam API
//
//  Created by Jack Cook on 3/25/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import SwiftyJSON

/// A user object.
public struct BeamUser {
    
    /// The user's identifier.
    public let id: Int
    
    /// The user's username.
    public let username: String
    
    /// The user's email address. Only returned if this is the authenticated user's object.
    public let email: String?
    
    /// True if the user has verified their email address.
    public let verified: Bool
    
    /// The number of experience points earned by the user.
    public let experience: Int
    
    /// The number of sparks that the user has.
    public let sparks: Int
    
    /// A url of the user's avatar.
    public let avatarUrl: String
    
    /// A biography written by the user.
    public let bio: String?
    
    /// The groups held by the user.
    public let groups: [BeamGroup]?
    
    /// The user's preferences. Only retrieved if this is the authenticated user's object.
    public let preferences: [String: AnyObject]?
    
    /// The user's Twitter profile URL.
    public var twitter: String?
    
    /// The user's Facebook profile URL.
    public var facebook: String?
    
    /// The user's YouTube channel URL.
    public var youtube: String?
    
    /// The user's player.me profile URL.
    public var player: String?
    
    /// Used to initialize a user object given JSON data.
    public init(json: JSON) {
        if let social = json["social"].dictionary {
            twitter = social["twitter"]?.string
            facebook = social["facebook"]?.string
            youtube = social["youtube"]?.string
            player = social["player"]?.string
        }
        
        id = json["id"].int ?? 0
        username = json["username"].string ?? ""
        email = json["email"].string
        verified = json["verified"].bool ?? false
        experience = json["experience"].int ?? 0
        sparks = json["sparks"].int ?? 0
        avatarUrl = json["avatarUrl"].string ?? "https://beam.pro/_latest/img/app/avatars/default.jpg"
        bio = json["bio"].string
        
        groups = [BeamGroup]()
        if let groups = json["groups"].array {
            for group in groups {
                if let name = group["name"].string {
                    let retrieved_group = BeamGroup(rawValue: name)
                    
                    if let group = retrieved_group {
                        self.groups!.append(group)
                    }
                }
            }
        }
        
        preferences = [String: AnyObject]()
        if let preferences = json["preferences"].dictionaryObject {
            for (key, val) in preferences {
                self.preferences![key] = val
            }
        }
    }
}
