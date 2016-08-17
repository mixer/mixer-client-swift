//
//  InteractiveErrorPacket.swift
//  Pods
//
//  Created by Jack Cook on 3/5/16.
//
//

import SwiftyJSON

/// A packet received when an error has occurred with Interactive.
public class InteractiveErrorPacket: InteractivePacket {
    
    /// The error message.
    public let message: String
    
    /// Initializes an interactive error packet with JSON data.
    override init?(data: JSON) {
        if let message = data["message"].string {
            self.message = message
            
            super.init(data: data)
        } else {
            return nil
        }
    }
}
