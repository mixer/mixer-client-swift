//
//  MessagePacket.swift
//  Beam API
//
//  Created by Jack Cook on 5/26/15.
//  Copyright (c) 2015 MCProHosting. All rights reserved.
//

public class MessagePacket: Packet, Sendable {
    
    public var message: BeamMessage?
    public var messageText: String?
    
    public init(message: BeamMessage) {
        self.message = message
    }
    
    public init(message: String) {
        messageText = message
    }
    
    public var identifier: String {
        return "msg"
    }
    
    public func arguments() -> [AnyObject] {
        var objects = [AnyObject]()
        
        if let messageText = messageText {
            objects.append(messageText)
        }
        
        return objects
    }
}
