//
//  ChatHistoryPacket.swift
//  Pods
//
//  Created by Jack Cook on 3/9/16.
//
//

/// A packet sent to request the most recent chat messages sent to a channel.
public class ChatHistoryPacket: ChatPacket, ChatSendable {
    
    /// The number of messages being requested.
    public let quantity: Int
    
    /**
     Used to initialize a chat history packet.
     
     :param: The number of chat messages being requested.
     */
    public init(quantity: Int) {
        self.quantity = quantity
        
        super.init()
    }
    
    public var identifier: String {
        return "history"
    }
    
    public func arguments() -> [AnyObject] {
        return [quantity]
    }
}
