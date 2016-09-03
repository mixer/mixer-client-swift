//
//  ChatErrorPacket.swift
//  Pods
//
//  Created by Jack Cook on 9/3/16.
//
//

/// A packet telling the app about an error.
public class ChatErrorPacket: ChatPacket {
    
    /// The error that occurred.
    public let error: String
    
    /// Initializes a chat error packet with an error.
    init(error: String) {
        self.error = error
        
        super.init()
    }
}
