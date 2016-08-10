//
//  ConstellationUserResubscribedPacket.swift
//  Pods
//
//  Created by Jack Cook on 8/10/16.
//
//

import SwiftyJSON

/// A user resubscribed packet is sent down when a user resubscribes to a channel.
public class ConstellationUserResubscribedPacket: ConstellationLivePacket {
    
    /// The id of the user who this event corresponds to.
    public let userId: Int
    
    /// The id of the the user is resubscribing to.
    public let channelId: Int
    
    /// The number of months the user has been subscribed for.
    public let totalMonths: Int
    
    /// The date at which the user's subscription began.
    public let since: NSDate?
    
    /// The date at which the user's subscription will end.
    public let until: NSDate?
    
    /// Initializes a resubscribed packet with JSON data.
    override init?(data: [String: JSON]) {
        if let channel = data["channel"]?.string, payload = data["payload"], channelId = payload["channel"].int, totalMonths = payload["totalMonths"].int {
            self.userId = Int(channel.componentsSeparatedByString(":")[1])!
            self.channelId = channelId
            self.totalMonths = totalMonths
            self.since = NSDate.fromBeam(payload["since"].string)
            self.until = NSDate.fromBeam(payload["until"].string)
            
            super.init(data: data)
        } else {
            return nil
        }
    }
}
