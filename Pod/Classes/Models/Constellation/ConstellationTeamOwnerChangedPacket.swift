//
//  ConstellationTeamOwnerChangedPacket.swift
//  Pods
//
//  Created by Jack Cook on 8/10/16.
//
//

import SwiftyJSON

/// A team owner changed packet is sent down when a team has a new owner.
public class ConstellationTeamOwnerChangedPacket: ConstellationLivePacket {
    
    /// The id of the team that this event corresponds to.
    public let teamId: Int
    
    /// The new owner of the team.
    public let owner: MixerUser
    
    /// Initializes a team owner changed packet with JSON data.
    override init?(data: [String: JSON]) {
        if let channel = data["channel"]?.string, let payload = data["payload"] {
            self.teamId = Int(channel.components(separatedBy: ":")[1])!
            self.owner = MixerUser(json: payload)
            
            super.init(data: data)
        } else {
            return nil
        }
    }
}
