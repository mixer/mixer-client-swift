//
//  ConstellationReplyPacket.swift
//  Pods
//
//  Created by Jack Cook on 8/12/16.
//
//

import SwiftyJSON

/// A reply packet is sent in response to any packet sent to constellation.
public class ConstellationReplyPacket: ConstellationPacket {
    
    /// Matches the identifier of the packet it is responding to.
    public let id: Int
    
    /// The result of the sent packet.
    public let result: [String: AnyObject]?
    
    /// Any errors that occurred in response to the sent packet.
    public let error: ConstellationReplyError?
    
    /// Initializes a reply packet with JSON data.
    init(result: [String: AnyObject]?, error: [String: JSON]?, id: Int) {
        if let code = error?["code"]?.int, let message = error?["message"]?.string {
            self.error = ConstellationReplyError(code: code, message: message)
        } else {
            self.error = nil
        }
        
        self.result = result
        self.id = id
    }
}

public struct ConstellationReplyError {
    let code: Int
    let message: String
}
