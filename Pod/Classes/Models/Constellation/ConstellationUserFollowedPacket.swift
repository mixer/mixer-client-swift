//
//  ConstellationUserFollowedPacket.swift
//  Pods
//
//  Created by Jack Cook on 8/10/16.
//
//

import SwiftyJSON

/// A user followed packet is sent down when a user follows or unfollows a channel.
public class ConstellationUserFollowedPacket: ConstellationLivePacket {
    
    /// The id of the user who this event corresponds to.
    public let userId: Int
    
    /// The channel that was followed.
    public let followed: BeamChannel
    
    /// True if the user followed the channel, false if the user unfollowed the channel.
    public let following: Bool
    
    /// Initializes a user followed packet with JSON data.
    override init?(data: [String: JSON]) {
        if let channel = data["channel"]?.string, let payload = data["payload"], let following = payload["following"].bool {
            self.userId = Int(channel.components(separatedBy: ":")[1])!
            self.followed = BeamChannel(json: payload["channel"])
            self.following = following
            
            super.init(data: data)
        } else {
            return nil
        }
    }
}
