//
//  ConstellationUserUpdatePacket.swift
//  Pods
//
//  Created by Jack Cook on 8/10/16.
//
//

import SwiftyJSON

/// A user update packet is sent down when a user's data has been changed in some way.
public class ConstellationUserUpdatePacket: ConstellationLivePacket {
    
    /// The id of the user who this event corresponds to.
    public let userId: Int
    
    /// The user who was updated.
    public let user: MixerUser
    
    /// Initializes a user update packet with JSON data.
    override init?(data: [String: JSON]) {
        if let channel = data["channel"]?.string, let payload = data["payload"] {
            self.userId = Int(channel.components(separatedBy: ":")[1])!
            self.user = MixerUser(json: payload)
            
            super.init(data: data)
        } else {
            return nil
        }
    }
}
