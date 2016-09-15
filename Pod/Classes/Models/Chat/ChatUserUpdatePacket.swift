//
//  ChatUserUpdatePacket.swift
//  Beam API
//
//  Created by Jack Cook on 5/26/15.
//  Copyright (c) 2016 Beam Interactive, Inc. All rights reserved.
//

import SwiftyJSON

/// A packet received when a user's roles have been changed.
public class ChatUserUpdatePacket: ChatPacket {
    
    /// The new permissions held by the user.
    public let permissions: [String]
    
    /// The user's identifier.
    public let userId: Int
    
    /// The user's username.
    public let username: String
    
    /// The user's new roles.
    public let roles: [String]
    
    /// Initializes a chat user update packet with JSON data.
    override init?(data: [String: JSON]) {
        if let permissions = data["permissions"]?.array, let userId = data["user"]?.int, let username = data["username"]?.string, let roles = data["roles"]?.array {
            var parsedPermissions = [String]()
            
            for permission in permissions where permission.string != nil {
                parsedPermissions.append(permission.string!)
            }
            
            self.permissions = parsedPermissions
            
            self.userId = userId
            self.username = username
            
            var parsedRoles = [String]()
            
            for role in roles where role.string != nil {
                parsedRoles.append(role.string!)
            }
            
            self.roles = parsedRoles
            
            super.init(data: data)
        } else {
            return nil
        }
    }
}
