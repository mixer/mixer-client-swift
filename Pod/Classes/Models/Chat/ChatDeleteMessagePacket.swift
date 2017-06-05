//
//  ChatDeleteMessagePacket.swift
//  Mixer API
//
//  Created by Jack Cook on 6/29/15.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//

import SwiftyJSON

/// A packet telling the app to remove a message from the visible chat.
public class ChatDeleteMessagePacket: ChatPacket {
    
    /// The id of the message to be deleted.
    public let id: String
    
    /// Initializes a chat delete message packet with JSON data.
    override init?(data: [String: JSON]) {
        if let id = data["id"]?.string {
            self.id = id
            
            super.init(data: data)
        } else {
            return nil
        }
    }
}
