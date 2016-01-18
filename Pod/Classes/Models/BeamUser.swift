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
    public let verified: Bool
    public let experience: Int
    public let sparks: Int
    public let avatarUrl: String
    public let bio: String?
    
    public let groups: [BeamGroup]?
    
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
        
        id = json["id"].int!
        username = json["username"].string!
        verified = json["verified"].bool!
        experience = json["experience"].int!
        sparks = json["sparks"].int!
        avatarUrl = json["avatarUrl"].string == nil ? "https://beam.pro/_latest/img/app/avatars/default.jpg" : json["avatarUrl"].string!
        bio = json["bio"].string
        
        groups = [BeamGroup]()
        if let groups = json["groups"].array {
            for group in groups {
                let name = group["name"].string!
                let retrieved_group = BeamGroup(rawValue: name)
                
                if let group = retrieved_group {
                    self.groups!.append(group)
                }
            }
        }
    }
}
