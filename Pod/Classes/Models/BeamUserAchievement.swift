//
//  BeamUserAchievement.swift
//  Pods
//
//  Created by Jack Cook on 7/12/16.
//
//

import SwiftyJSON

/// An object detailing user progress made on an achievement.
public struct BeamUserAchievement {
    
    /// The achievement's identifier.
    public let id: Int
    
    /// Whether the user has earned the achievement or not.
    public let earned: Bool
    
    /// Progress made on the achievement, in the range [0, 1].
    public let progress: Float
    
    /// The date of the achievement's creation.
    public let createdAt: NSDate?
    
    /// The date the user last made progress on the achievement.
    public let updatedAt: NSDate?
    
    /// The slug/identifier of the achievement being discussed.
    public let achievementSlug: String?
    
    /// The identifier of the user who owns this achievement object.
    public let userId: Int
    
    /// The achievement being discussed.
    public let achievement: BeamAchievement
    
    /// Used to initialize a user achievement object given JSON data.
    init(json: JSON) {
        id = json["id"].int ?? 0
        earned = json["earned"].bool ?? false
        progress = json["progress"].float ?? 0
        createdAt = NSDate.fromBeam(json["createdAt"].string)
        updatedAt = NSDate.fromBeam(json["updatedAt"].string)
        achievementSlug = json["achievement"].string
        userId = json["user"].int ?? 0
        achievement = BeamAchievement(json: json["Achievement"])
    }
}
