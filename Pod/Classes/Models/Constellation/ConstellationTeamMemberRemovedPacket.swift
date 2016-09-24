//
//  ConstellationTeamMemberRemovedPacket.swift
//  Pods
//
//  Created by Jack Cook on 8/10/16.
//
//

import SwiftyJSON

/// A team member removed packet is sent down when a user is removed from a team.
public class ConstellationTeamMemberRemovedPacket: ConstellationLivePacket {
    
    /// The id of the team that this event corresponds to.
    public let teamId: Int
    
    /// The user who was removed from the team.
    public let user: BeamUser
    
    /// Initializes a team member removed packet with JSON data.
    override init?(data: [String: JSON]) {
        if let channel = data["channel"]?.string, let payload = data["payload"] {
            self.teamId = Int(channel.components(separatedBy: ":")[1])!
            self.user = BeamUser(json: payload)
            
            super.init(data: data)
        } else {
            return nil
        }
    }
}
