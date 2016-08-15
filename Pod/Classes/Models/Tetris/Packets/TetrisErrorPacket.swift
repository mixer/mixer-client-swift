//
//  TetrisErrorPacket.swift
//  Pods
//
//  Created by Jack Cook on 3/5/16.
//
//

/// A packet received when an error has occurred with tetris.
public class TetrisErrorPacket: TetrisPacket {
    
    /// The error message.
    public let message: String
    
    /**
     Used to initialize an error packet.
     
     :param: message The error message.
     */
    init(message: String) {
        self.message = message
    }
}
