//
//  ConstellationUserTeamRemovedPacket.swift
//  Pods
//
//  Created by Jack Cook on 8/10/16.
//
//

import SwiftyJSON

/// A user removed packet is sent down when a user has been removed from a stream team.
public class ConstellationUserTeamRemovedPacket: ConstellationLivePacket {
    
    /// The id of the user who this event corresponds to.
    public let userId: Int
    
    /// The team that the user was removed from.
    public let team: BeamTeam
    
    /// Initializes a user team removed packet with JSON data.
    override init?(data: [String: JSON]) {
        if let channel = data["channel"]?.string, let payload = data["payload"] {
            self.userId = Int(channel.components(separatedBy: ":")[1])!
            self.team = BeamTeam(json: payload)
            
            super.init(data: data)
        } else {
            return nil
        }
    }
}
