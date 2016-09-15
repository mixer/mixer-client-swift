//
//  ConstellationChannelResubscribedPacket.swift
//  Pods
//
//  Created by Jack Cook on 8/10/16.
//
//

import SwiftyJSON

/// A channel resubscribed packet is sent down when a user has resubscribed to a channel.
public class ConstellationChannelResubscribedPacket: ConstellationLivePacket {
    
    /// The id of the channel that this event corresponds to.
    public let channelId: Int
    
    /// The user who resubscribed to the channel.
    public let user: BeamUser
    
    /// The number of months the user has been subscribed for.
    public let totalMonths: Int
    
    /// Initializes a channel resubscribed packet with JSON data.
    override init?(data: [String: JSON]) {
        if let channel = data["channel"]?.string, let payload = data["payload"], let totalMonths = payload["totalMonths"].int {
            self.channelId = Int(channel.componentsSeparatedByString(":")[1])!
            self.user = BeamUser(json: payload["user"])
            self.totalMonths = totalMonths
            
            super.init(data: data)
        } else {
            return nil
        }
    }
}
