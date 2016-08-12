//
//  ConstellationHelloPacket.swift
//  Pods
//
//  Created by Jack Cook on 8/10/16.
//
//

import SwiftyJSON

/// A hello event is sent down to the client when they first connect.
public class ConstellationHelloPacket: ConstellationPacket {
    
    /// True if the socket consumer authenticated as a user rather than a guest.
    public let authenticated: Bool
    
    /// Initializes a hello packet with JSON data.
    init?(data: [String: JSON]) {
        if let authenticated = data["authenticated"]?.bool {
            self.authenticated = authenticated
        } else {
            return nil
        }
    }
}
