//
//  ConstellationTeamMemberAcceptedPacket.swift
//  Pods
//
//  Created by Jack Cook on 8/10/16.
//
//

import SwiftyJSON

/// A team member accepted packet is sent down when someone has accepted to join a stream team.
public class ConstellationTeamMemberAcceptedPacket: ConstellationLivePacket {
    
    /// The id of the team that this event corresponds to.
    public let teamId: Int
    
    /// The team that got a new member.
    public let team: BeamTeam
    
    /// Initializes a team member accepted packet with JSON data.
    override init?(data: [String: JSON]) {
        if let channel = data["channel"]?.string, let payload = data["payload"] {
            self.teamId = Int(channel.componentsSeparatedByString(":")[1])!
            self.team = BeamTeam(json: payload)
            
            super.init(data: data)
        } else {
            return nil
        }
    }
}
