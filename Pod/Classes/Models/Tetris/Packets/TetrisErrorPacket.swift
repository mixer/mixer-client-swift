//
//  TetrisErrorPacket.swift
//  Pods
//
//  Created by Jack Cook on 3/5/16.
//
//

import SwiftyJSON

/// A packet received when an error has occurred with tetris.
public class TetrisErrorPacket: TetrisPacket {
    
    /// The error message.
    public let message: String
    
    /// Initializes a tetris error packet with JSON data.
    override init?(data: JSON) {
        if let message = data["message"].string {
            self.message = message
            
            super.init(data: data)
        } else {
            return nil
        }
    }
}
