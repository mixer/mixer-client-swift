//
//  VotePacket.swift
//  Beam API
//
//  Created by Jack Cook on 5/26/15.
//  Copyright (c) 2016 Beam Interactive, Inc. All rights reserved.
//

/// A packet sent to vote in a poll.
public class VotePacket: Packet, Sendable {
    
    /// The option chosen by the user.
    public let option: Int
    
    /**
     Used to initialize a vote packet.
     
     :param: option The option chosen by the user.
     */
    public init(option: Int) {
        self.option = option
    }
    
    public var identifier: String {
        return "vote:choose"
    }
    
    public func arguments() -> [AnyObject] {
        var objects = [AnyObject]()
        
        objects.append(option)
        
        return objects
    }
}
