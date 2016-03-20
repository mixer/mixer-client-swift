//
//  UserLeavePacket.swift
//  Beam API
//
//  Created by Jack Cook on 5/26/15.
//  Copyright (c) 2015 MCProHosting. All rights reserved.
//

/// A packet received when a user has left the channel.
public class UserLeavePacket: Packet {
    
    /// The username of the user who left.
    public let username: String
    
    /// The roles held by the user who left.
    public let roles: [String]
    
    /// The id of the user who left.
    public let userId: Int
    
    /**
     Used to initialize a user leave packet.
     
     :param: username The username of the user who left.
     :param: roles The roles held by the user who left.
     :param: userId The id of the user who left.
     */
    init(username: String, roles: [String], userId: Int) {
        self.username = username
        self.roles = roles
        self.userId = userId
    }
}
