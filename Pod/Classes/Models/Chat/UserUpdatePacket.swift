//
//  UserUpdatePacket.swift
//  Beam API
//
//  Created by Jack Cook on 5/26/15.
//  Copyright (c) 2015 MCProHosting. All rights reserved.
//

public class UserUpdatePacket: Packet {
    
    public let permissions: [String]?
    public let userId: Int?
    public let username: String?
    public let roles: [String]?
    
    public init(permissions: [String], userId: Int, username: String, roles: [String]) {
        self.permissions = permissions
        self.userId = userId
        self.username = username
        self.roles = roles
    }
}
