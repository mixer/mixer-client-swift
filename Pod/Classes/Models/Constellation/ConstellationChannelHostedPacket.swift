//
//  ConstellationChannelHostedPacket.swift
//  Pods
//
//  Created by Jack Cook on 8/10/16.
//
//

import SwiftyJSON

/// A channel hosted packet is sent down when a channel has been hosted.
public class ConstellationChannelHostedPacket: ConstellationLivePacket {
    
    /// The id of the channel that this event corresponds to.
    public let channelId: Int
    
    /// The channel that hosted the channel.
    public let host: BeamChannel
    
    /// Initializes a channel hosted packet with JSON data.
    override init?(data: [String: JSON]) {
        if let channel = data["channel"]?.string, let payload = data["payload"] {
            self.channelId = Int(channel.components(separatedBy: ":")[1])!
            self.host = BeamChannel(json: payload["hoster"])
            
            super.init(data: data)
        } else {
            return nil
        }
    }
}
