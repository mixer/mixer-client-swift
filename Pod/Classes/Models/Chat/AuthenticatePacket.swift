//
//  AuthenticatePacket.swift
//  Beam API
//
//  Created by Jack Cook on 5/26/15.
//  Copyright (c) 2015 MCProHosting. All rights reserved.
//

public class AuthenticatePacket: Packet, Sendable {
    
    public let channelId: Int?
    public var userId: Int?
    public var authKey: String?
    
    public init(channelId: Int) {
        self.channelId = channelId
    }
    
    public init(channelId: Int, userId: Int, authKey: String) {
        self.channelId = channelId
        self.userId = userId
        self.authKey = authKey
    }
    
    public var identifier: String {
        return "auth"
    }
    
    public func arguments() -> [AnyObject] {
        var objects = [AnyObject]()
        
        if let channelId = channelId {
            objects.append(channelId)
        }
        
        if let userId = userId {
            objects.append(userId)
        }
        
        if let authKey = authKey {
            objects.append(authKey)
        }
        
        return objects
    }
}
