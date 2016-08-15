//
//  ChatAuthenticatePacket.swift
//  Beam API
//
//  Created by Jack Cook on 5/26/15.
//  Copyright (c) 2016 Beam Interactive, Inc. All rights reserved.
//

/// A packet sent to tell the chat servers about the user's session. Needs to be used regardless of whether or not there is a locally authenticated user.
public class ChatAuthenticatePacket: ChatPacket, ChatSendable {
    
    /// The id of the channel being connected to.
    public let channelId: Int
    
    /// The id of the user being authenticated.
    public var userId: Int?
    
    /// The authentication key required by the chat servers.
    public var authKey: String?
    
    /**
     Used when there is no locally authenticated user.
     
     :param: channelId The id of the channel being connected to.
     */
    public init(channelId: Int) {
        self.channelId = channelId
    }
    
    /**
     Used when there is a locally authenticated user.
     
     :param: channelId The id of the channel being connected to.
     :param: userId The id of the locally authenticated user.
     :param: authKey The authentication key returned by ChatRoutes.getChatDetailsById.
     */
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
        
        objects.append(channelId)
        
        if let userId = userId {
            objects.append(userId)
        }
        
        if let authKey = authKey {
            objects.append(authKey)
        }
        
        return objects
    }
}
