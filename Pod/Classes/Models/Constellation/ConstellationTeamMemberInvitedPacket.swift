//
//  ConstellationTeamMemberInvitedPacket.swift
//  Pods
//
//  Created by Jack Cook on 8/10/16.
//
//

import SwiftyJSON

/// A team member invited packet is sent down when a user has been invited to join a stream team.
public class ConstellationTeamMemberInvitedPacket: ConstellationLivePacket {
    
    /// The id of the team that this event corresponds to.
    public let teamId: Int
    
    /// The user who was invited.
    public let user: MixerUser
    
    /// Initializes a team member invited packet with JSON data.
    override init?(data: [String: JSON]) {
        if let channel = data["channel"]?.string, let payload = data["payload"] {
            self.teamId = Int(channel.components(separatedBy: ":")[1])!
            self.user = MixerUser(json: payload)
            
            super.init(data: data)
        } else {
            return nil
        }
    }
}
