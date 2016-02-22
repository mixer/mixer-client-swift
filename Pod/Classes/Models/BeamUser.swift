//
//  BeamUser.swift
//  Beam API
//
//  Created by Jack Cook on 3/25/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import SwiftyJSON

public struct BeamUser {
    
    public let id: Int
    public let username: String
    public let email: String?
    public let verified: Bool
    public let experience: Int
    public let sparks: Int
    public let avatarUrl: String
    public let bio: String?
    
    public let groups: [BeamGroup]?
    public let preferences: [String: AnyObject]?
    
    public var twitter: String?
    public var facebook: String?
    public var youtube: String?
    public var player: String?
    
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
