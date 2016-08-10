//
//  ConstellationLivePacket.swift
//  Pods
//
//  Created by Jack Cook on 8/10/16.
//
//

import SwiftyJSON

/// A live packet is sent down to the client when an event fires.
public class ConstellationLivePacket: ConstellationPacket {
    
    /// The event that this live packet corresponds to.
    public let channel: String
    
    /// The payload containing updated data as a result of this event.
    public let payload: JSON
    
    /// Initializes a live packet with JSON data.
    init?(data: [String: JSON]) {
        if let channel = data["channel"]?.string, payload = data["payload"] {
            self.channel = channel
            self.payload = payload
        } else {
            return nil
        }
    }
}
