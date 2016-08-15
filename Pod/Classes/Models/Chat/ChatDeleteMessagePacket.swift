//
//  ChatDeleteMessagePacket.swift
//  Beam API
//
//  Created by Jack Cook on 6/29/15.
//  Copyright (c) 2016 Beam Interactive, Inc. All rights reserved.
//

/// A packet telling the app to remove a message from the visible chat.
public class ChatDeleteMessagePacket: ChatPacket {
    
    /// The id of the message to be deleted.
    public var id: String
    
    /**
     Used to initialize a delete message packet.
     
     :param: id The id of the message to be deleted.
     */
    init(id: String) {
        self.id = id
    }
}
