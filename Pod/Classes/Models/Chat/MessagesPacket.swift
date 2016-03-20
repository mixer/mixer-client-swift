//
//  MessagesPacket.swift
//  Pods
//
//  Created by Jack Cook on 3/9/16.
//
//

/// A packet containing messages returned in response to a chat history command.
public class MessagesPacket: Packet {
    
    /// The messages that were received.
    public var packets: [MessagePacket]
    
    /**
     Used to initialize a messages packet.
     
     :param: packets The messages that have been received.
     */
    init(packets: [MessagePacket]) {
        self.packets = packets
    }
}
