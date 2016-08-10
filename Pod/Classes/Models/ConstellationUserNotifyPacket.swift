//
//  ConstellationUserNotifyPacket.swift
//  Pods
//
//  Created by Jack Cook on 8/10/16.
//
//

import SwiftyJSON

/// A user notify packet is sent down whenever a followed channel goes live, while abiding by the user's notification settings.
public class ConstellationUserNotifyPacket: ConstellationLivePacket {
    
    /// The id of the user who this event corresponds to.
    public let userId: Int
    
    /// The notification being sent.
    public let notification: BeamNotification
    
    /// Initializes a user notify packet with JSON data.
    override init?(data: [String: JSON]) {
        if let channel = data["channel"]?.string, payload = data["payload"] {
            self.userId = Int(channel.componentsSeparatedByString(":")[1])!
            self.notification = BeamNotification(json: payload)
            
            super.init(data: data)
        } else {
            return nil
        }
    }
}
