//
//  MixerTeam.swift
//  Pods
//
//  Created by Jack Cook on 7/13/16.
//
//

import SwiftyJSON

/// A team object.
public struct MixerTeam {
    
    /// The team's identifier.
    public let id: Int
    
    /// The user id of the team's owner.
    public let ownerId: Int
    
    /// The team's token.
    public let token: String
    
    /// The team's name.
    public let name: String
    
    /// The team's description.
    public let description: String?
    
    /// The url of the team's logo image.
    public let logoUrl: URL?
    
    /// The url of the team's background image.
    public let backgroundUrl: URL?
    
    /// The current number of viewers across all of the team's channels.
    public let totalViewersCurrent: Int
    
    /// The date, in UTC, on which the team was created.
    public let createdAt: Date?
    
    /// The date, in UTC, on which the channel was last updated.
    public let updatedAt: Date?
    
    /// The team's Twitter profile URL.
    public let twitter: String?
    
    /// The team's Facebook profile URL.
    public let facebook: String?
    
    /// The team's YouTube channel URL.
    public let youtube: String?
    
    /// The team's player.me profile URL.
    public let player: String?
    
    /// Used to initialize a team object given JSON data.
    init(json: JSON) {
        id = json["id"].int ?? 0
        ownerId = json["ownerId"].int ?? 0
        token = json["token"].string ?? ""
        name = json["name"].string ?? ""
        description = json["description"].string ?? ""
        
        if let logo = json["logoUrl"].string {
            logoUrl = URL(string: logo)
        } else {
            logoUrl = nil
        }
        
        if let background = json["backgroundUrl"].string {
            backgroundUrl = URL(string: background)
        } else {
            backgroundUrl = nil
        }
        
        totalViewersCurrent = json["totalViewersCurrent"].int ?? 0
        createdAt = Date.fromMixer(json["createdAt"].string)
        updatedAt = Date.fromMixer(json["updatedAt"].string)
        
        if let social = json["social"].dictionary {
            twitter = social["twitter"]?.string
            facebook = social["facebook"]?.string
            youtube = social["youtube"]?.string
            player = social["player"]?.string
        } else {
            twitter = nil
            facebook = nil
            youtube = nil
            player = nil
        }
    }
}
