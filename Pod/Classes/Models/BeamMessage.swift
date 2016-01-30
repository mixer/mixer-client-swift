//
//  BeamMessage.swift
//  Beam API
//
//  Created by Jack Cook on 4/25/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import SwiftyJSON

public struct BeamMessage {
    
    public let components: [BeamMessageComponent]!
    public let channel: Int?
    public let id: String?
    public let userId: Int?
    public let userName: String?
    public let userRoles: [BeamGroup]?
    
    public init(json: JSON) {
        components = [BeamMessageComponent]()
        
        if let message = json["message"].dictionary,
            meta = message["meta"]?.dictionary {
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
