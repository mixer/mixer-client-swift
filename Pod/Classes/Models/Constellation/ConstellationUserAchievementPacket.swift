//
//  ConstellationUserAchievementPacket.swift
//  Pods
//
//  Created by Jack Cook on 8/10/16.
//
//

import SwiftyJSON

/// A user achievement packet is sent down when a user has made progress on an achievement.
public class ConstellationUserAchievementPacket: ConstellationLivePacket {
    
    /// The id of the user who this event corresponds to.
    public let userId: Int
    
    /// The achievement that has been updated.
    public let achievement: BeamAchievement
    
    /// Initializes a user achievement packet with JSON data.
    override init?(data: [String: JSON]) {
        if let channel = data["channel"]?.string, let payload = data["payload"] {
            self.userId = Int(channel.componentsSeparatedByString(":")[1])!
            self.achievement = BeamAchievement(json: payload)
            
            super.init(data: data)
        } else {
            return nil
        }
    }
}
