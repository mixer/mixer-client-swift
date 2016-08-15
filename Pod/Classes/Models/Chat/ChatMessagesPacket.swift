//
//  ChatMessagesPacket.swift
//  Pods
//
//  Created by Jack Cook on 3/9/16.
//
//

/// A packet containing messages returned in response to a chat history command.
public class ChatMessagesPacket: ChatPacket {
    
    /// The messages that were received.
    public var packets: [ChatMessagePacket]
    
    /**
     Used to initialize a messages packet.
     
     :param: packets The messages that have been received.
     */
    init(packets: [ChatMessagePacket]) {
        self.packets = packets
    }
}
