//
//  ChatMessagesPacket.swift
//  Pods
//
//  Created by Jack Cook on 3/9/16.
//
//

import SwiftyJSON

/// A packet containing messages returned in response to a chat history command.
public class ChatMessagesPacket: ChatPacket {
    
    /// The messages that were received.
    public var packets: [ChatMessagePacket]
    
    override init?(data: [JSON]) {
        var packets = [ChatMessagePacket]()
        
        for datum in data {
            if let messagePacket = ChatMessagePacket(data: datum) {
                packets.append(messagePacket)
            }
        }
        
        self.packets = packets
        
        super.init(data: data)
    }
}
