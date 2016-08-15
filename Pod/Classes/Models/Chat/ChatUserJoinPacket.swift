//
//  ChatUserJoinPacket.swift
//  Beam API
//
//  Created by Jack Cook on 5/26/15.
//  Copyright (c) 2016 Beam Interactive, Inc. All rights reserved.
//

import SwiftyJSON

/// A packet received when a user has joined the channel.
public class ChatUserJoinPacket: ChatPacket {
    
    /// The username of the user who joined.
    public let username: String
    
    /// The roles held by the user who joined.
    public let roles: [String]
    
    /// The id of the user who joined.
    public let userId: Int
    
    /// Initializes a chat user join packet with JSON data.
    override init?(data: [String: JSON]) {
        if let username = data["username"]?.string, roles = data["roles"]?.array, userId = data["id"]?.int {
            self.username = username
            
            var parsedRoles = [String]()
            
            for role in roles where role.string != nil {
                parsedRoles.append(role.string!)
            }
            
            self.roles = parsedRoles
            
            self.userId = userId
            
            super.init(data: data)
        } else {
            return nil
        }
    }
}
