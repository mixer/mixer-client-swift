//
//  MessagesPacket.swift
//  Pods
//
//  Created by Jack Cook on 3/9/16.
//
//

public class MessagesPacket: Packet {
    
    public var packets: [MessagePacket]
    
    public init(packets: [MessagePacket]) {
        self.packets = packets
    }
}
