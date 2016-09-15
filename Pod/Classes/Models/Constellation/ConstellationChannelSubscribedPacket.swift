//
//  ConstellationChannelSubscribedPacket.swift
//  Pods
//
//  Created by Jack Cook on 8/10/16.
//
//

import SwiftyJSON

/// A channel subscribed packet is sent down when a user subscribes to the channel.
public class ConstellationChannelSubscribedPacket: ConstellationLivePacket {
    
    /// The id of the channel that this event corresponds to.
    public let channelId: Int
    
    /// The user who subscribed to the channel.
    public let user: BeamUser
    
    /// Initializes a channel subscribed packet with JSON data.
    override init?(data: [String: JSON]) {
        if let channel = data["channel"]?.string, let payload = data["payload"] {
            self.channelId = Int(channel.componentsSeparatedByString(":")[1])!
            self.user = BeamUser(json: payload["user"])
            
            super.init(data: data)
        } else {
            return nil
        }
    }
}
