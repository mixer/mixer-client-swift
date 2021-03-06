//
//  ChatMessagePacket.swift
//  Mixer API
//
//  Created by Jack Cook on 5/26/15.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//

import SwiftyJSON

/// A packet containing data about a message. Can be sent or received.
public class ChatMessagePacket: ChatPacket, ChatSendable {
    
    /// A message object. Used when the packet is being received.
    public var message: MixerMessage?
    
    /// A string of text being sent to the chat servers as a message. Used when the packet is being sent.
    public var messageText: String?
    
    /// Initializes a chat message packet with JSON data.
    override init?(data: [String: JSON]) {
        self.message = MixerMessage(json: JSON(data))
        super.init(data: data)
    }
    
    /// Initializes a chat message packet with JSON data.
    init?(data: JSON) {
        self.message = MixerMessage(json: data)
        super.init(data: ["data": data])
    }
    
    /// Initializes a chat message packet with a message string.
    public init(message: String) {
        messageText = message
        super.init()
    }
    
    public var identifier: String {
        return "msg"
    }
    
    public func arguments() -> [AnyObject] {
        var objects = [AnyObject]()
        
        if let messageText = messageText {
            objects.append(messageText as AnyObject)
        }
        
        return objects
    }
}
