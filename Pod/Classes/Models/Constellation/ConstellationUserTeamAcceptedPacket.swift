//
//  ConstellationUserTeamAcceptedPacket.swift
//  Pods
//
//  Created by Jack Cook on 8/10/16.
//
//

import SwiftyJSON

/// A user team accepted packet is sent down when a user accepts a stream team invitation.
public class ConstellationUserTeamAcceptedPacket: ConstellationLivePacket {
    
    /// The id of the user who this event corresponds to.
    public let userId: Int
    
    /// The team that the user has joined.
    public let team: BeamTeam
    
    /// Initializes a user team accepted packet with JSON data.
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
