//
//  MessagePacket.swift
//  Beam API
//
//  Created by Jack Cook on 5/26/15.
//  Copyright (c) 2015 MCProHosting. All rights reserved.
//

/// A packet containing data about a message. Can be sent or received.
public class MessagePacket: Packet, Sendable {
    
    /// A message object. Used when the packet is being received.
    public var message: BeamMessage?
    
    /// A string of text being sent to the chat servers as a message. Used when the packet is being sent.
    public var messageText: String?
    
    /**
     Used to initialize a message packet when the message is being received.
     
     :param: message The message object.
     */
    init(message: BeamMessage) {
        self.message = message
    }
    
    /**
     Used ot initialize a message packet when the message is being sent.
     
     :param: message The text to be sent to the chat servers.
     */
    public init(message: String) {
        messageText = message.stringByReplacingOccurrencesOfString("\"", withString: "\\\"")
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
