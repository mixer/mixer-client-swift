//
//  HandshakeAcknowledgmentPacket.swift
//  Pods
//
//  Created by Jack Cook on 3/5/16.
//
//

public class HandshakeAcknowledgmentPacket: TetrisPacket {
    
    public let state: String
    
    public init(state: String) {
        self.state = state
    }
}
