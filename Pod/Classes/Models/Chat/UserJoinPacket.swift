//
//  UserJoinPacket.swift
//  Beam API
//
//  Created by Jack Cook on 5/26/15.
//  Copyright (c) 2015 MCProHosting. All rights reserved.
//

public class UserJoinPacket: Packet {
    
    public let username: String?
    public let roles: [String]?
    public let userId: Int?
    
    public init(username: String, roles: [String], userId: Int) {
        self.username = username
        self.roles = roles
        self.userId = userId
    }
}
