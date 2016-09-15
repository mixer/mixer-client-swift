//
//  BeamMessage.swift
//  Beam API
//
//  Created by Jack Cook on 4/25/15.
//  Copyright (c) 2016 Beam Interactive, Inc. All rights reserved.
//

import SwiftyJSON

/// A chat message object.
public struct BeamMessage {
    
    /// The components that make up the chat message.
    public let components: [BeamMessageComponent]!
    
    /// The id of the channel that the message was sent to.
    public let channel: Int?
    
    /// The message's identifier.
    public let id: String?
    
    /// The id of the user who sent the message.
    public let userId: Int?
    
    /// The name of the user who sent the message.
    public let userName: String?
    
    /// The roles held by the user who sent the message.
    public let userRoles: [BeamGroup]?
    
    /// Used to initialize a chat message given JSON data.
    init(json: JSON) {
        components = [BeamMessageComponent]()
        
        if let message = json["message"].dictionary, let meta = message["meta"]?.dictionary {
            var me = false
            
            if let flag = meta["me"]?.bool {
                me = flag
            }
            
            if let components = message["message"]?.array {
                for component in components {
                    let message_component = BeamMessageComponent(json: component, me: me)
                    self.components.append(message_component)
                }
            }
        }
        
        channel = json["channel"].int
        id = json["id"].string
        userId = json["user_id"].int
        userName = json["user_name"].string
        
        userRoles = [BeamGroup]()
        
        if let roles = json["user_roles"].array {
            for role in roles {
                if let roleString = role.string {
                    if let user_role = BeamGroup(rawValue: roleString) {
                        userRoles!.append(user_role)
                    } else {
                        userRoles!.append(BeamGroup.User)
                    }
                }
            }
        }
    }
}
