//
//  TetrisHandshakeAcknowledgmentPacket.swift
//  Pods
//
//  Created by Jack Cook on 3/5/16.
//
//

import SwiftyJSON

/// A packet received when a handshake has been acknowledged by the tetris servers.
public class TetrisHandshakeAcknowledgmentPacket: TetrisPacket {
    
    /// The current control state.
    public let state: String
    
    /// Initializes a tetris handshake acknowledgment packet with JSON data.
    override init?(data: JSON) {
        if let state = data["state"].string {
            self.state = state
            
            super.init(data: data)
        } else {
            return nil
        }
    }
}
