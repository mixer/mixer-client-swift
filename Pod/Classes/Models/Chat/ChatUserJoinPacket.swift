//
//  ChatUserJoinPacket.swift
//  Beam API
//
//  Created by Jack Cook on 5/26/15.
//  Copyright (c) 2016 Beam Interactive, Inc. All rights reserved.
//

/// A packet received when a user has joined the channel.
public class ChatUserJoinPacket: ChatPacket {
    
    /// The username of the user who joined.
    public let username: String
    
    /// The roles held by the user who joined.
    public let roles: [String]
    
    /// The id of the user who joined.
    public let userId: Int
    
    /**
     Used to initialize a user join packet.
     
     :param: username The username of the user who joined.
     :param: roles The roles held by the user who joined.
     :param: userId The id of the user who joined.
     */
    init(username: String, roles: [String], userId: Int) {
        self.username = username
        self.roles = roles
        self.userId = userId
    }
}
