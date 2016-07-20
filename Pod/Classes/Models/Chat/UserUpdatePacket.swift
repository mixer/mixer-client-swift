//
//  UserUpdatePacket.swift
//  Beam API
//
//  Created by Jack Cook on 5/26/15.
//  Copyright (c) 2016 Beam Interactive, Inc. All rights reserved.
//

/// A packet received when a user's roles have been changed.
public class UserUpdatePacket: Packet {
    
    /// The new permissions held by the user.
    public let permissions: [String]
    
    /// The user's identifier.
    public let userId: Int
    
    /// The user's username.
    public let username: String
    
    /// The user's new roles.
    public let roles: [String]
    
    /**
     Used to initialize a user update packet.
     
     :param: The new permissions held by the user.
     :param: userId The user's identifier.
     :param: username The user's username.
     :param: roles The user's new roles.
     */
    init(permissions: [String], userId: Int, username: String, roles: [String]) {
        self.permissions = permissions
        self.userId = userId
        self.username = username
        self.roles = roles
    }
}
