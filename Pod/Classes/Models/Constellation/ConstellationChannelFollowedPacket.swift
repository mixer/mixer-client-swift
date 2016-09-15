//
//  ConstellationChannelFollowedPacket.swift
//  Pods
//
//  Created by Jack Cook on 8/10/16.
//
//

import SwiftyJSON

/// A channel followed packet is sent down when a channel has been followed or unfollowed.
public class ConstellationChannelFollowedPacket: ConstellationLivePacket {
    
    /// The id of the channel that this event corresponds to.
    public let channelId: Int
    
    /// The user who followed or unfollowed the channel.
    public let user: BeamUser
    
    /// True if the user followed the channel, false if the user unfollowed the channel.
    public let following: Bool
    
    /// Initializes a channel followed packet with JSON data.
    override init?(data: [String: JSON]) {
        if let channel = data["channel"]?.string, let payload = data["payload"], let following = payload["following"].bool {
            self.channelId = Int(channel.componentsSeparatedByString(":")[1])!
            self.user = BeamUser(json: payload["user"])
            self.following = following
            
            super.init(data: data)
        } else {
            return nil
        }
    }
}
