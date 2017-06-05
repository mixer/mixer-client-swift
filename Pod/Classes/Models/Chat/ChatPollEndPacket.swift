//
//  ChatPollEndPacket.swift
//  Mixer API
//
//  Created by Jack Cook on 5/26/15.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//

import SwiftyJSON

/// A packet received when a poll has ended.
public class ChatPollEndPacket: ChatPacket {
    
    /// The number of people who voted in the poll.
    public let voters: Int
    
    /// The responses made by poll voters.
    public let responses: [String: Int]
    
    /// Initializes a chat poll end packet with JSON data.
    override init?(data: [String: JSON]) {
        if let voters = data["voters"]?.int, let responses = data["responses"]?.dictionaryObject as? [String: Int] {
            self.voters = voters
            self.responses = responses
            
            super.init(data: data)
        } else {
            return nil
        }
    }
}
