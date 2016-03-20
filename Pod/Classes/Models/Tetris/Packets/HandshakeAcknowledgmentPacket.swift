//
//  HandshakeAcknowledgmentPacket.swift
//  Pods
//
//  Created by Jack Cook on 3/5/16.
//
//

/// A packet received when a handshake has been acknowledged by the tetris servers.
public class HandshakeAcknowledgmentPacket: TetrisPacket {
    
    /// The current control state.
    public let state: String
    
    /**
     Used to initialize a handshake acknowledgment packet.
     
     :param: state The current control state.
     */
    init(state: String) {
        self.state = state
    }
}
