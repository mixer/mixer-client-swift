//
//  ChatVotePacket.swift
//  Mixer API
//
//  Created by Jack Cook on 5/26/15.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//

/// A packet sent to vote in a poll.
public class ChatVotePacket: ChatPacket, ChatSendable {
    
    /// The option chosen by the user.
    public let option: Int
    
    /**
     Used to initialize a vote packet.
     
     :param: option The option chosen by the user.
     */
    public init(option: Int) {
        self.option = option
        
        super.init()
    }
    
    public var identifier: String {
        return "vote:choose"
    }
    
    public func arguments() -> [AnyObject] {
        var objects = [AnyObject]()
        
        objects.append(option as AnyObject)
        
        return objects
    }
}
