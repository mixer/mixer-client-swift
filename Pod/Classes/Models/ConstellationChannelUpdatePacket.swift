//
//  ConstellationChannelUpdatePacket.swift
//  Pods
//
//  Created by Jack Cook on 8/10/16.
//
//

import SwiftyJSON

/// A channel update packet is sent down when a variety of events occur that update the channel's state.
public class ConstellationChannelUpdatePacket: ConstellationLivePacket {
    
    /// The id of the channel that this event corresponds to.
    public let channelId: Int
    
    /// The channel that was updated.
    public let updated: BeamChannel
    
    /// Initializes a channel update packet with JSON data.
    override init?(data: [String : JSON]) {
        if let channel = data["channel"]?.string, payload = data["payload"] {
            self.channelId = Int(channel.componentsSeparatedByString(":")[1])!
            self.updated = BeamChannel(json: payload)
            
            super.init(data: data)
        } else {
            return nil
        }
    }
}
