//
//  ConstellationTeamDeletedPacket.swift
//  Pods
//
//  Created by Jack Cook on 8/10/16.
//
//

import SwiftyJSON

/// A team deleted packet is sent down when a team has been deleted.
public class ConstellationTeamDeletedPacket: ConstellationLivePacket {
    
    /// The id of the team that this event corresponds to.
    public let teamId: Int
    
    /// The team that was deleted.
    public let team: BeamTeam
    
    /// Initializes a team deleted packet with JSON data.
    override init?(data: [String: JSON]) {
        if let channel = data["channel"]?.string, payload = data["payload"] {
            self.teamId = Int(channel.componentsSeparatedByString(":")[1])!
            self.team = BeamTeam(json: payload["team"])
            
            super.init(data: data)
        } else {
            return nil
        }
    }
}
