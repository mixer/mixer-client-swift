//
//  ChatPollStartPacket.swift
//  Mixer API
//
//  Created by Jack Cook on 5/26/15.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//

import SwiftyJSON

/// A packet received when a poll has begun.
public class ChatPollStartPacket: ChatPacket {
    
    /// The options that can be chosen from.
    public let answers: [String]
    
    /// The poll's question.
    public let question: String
    
    /// The exact time at which the poll will end.
    public let endTime: Date
    
    /// The number of seconds that the poll will last for.
    public let duration: Int
    
    /// Initializes a chat poll start packet with JSON data.
    override init?(data: [String: JSON]) {
        if let answers = data["answers"]?.array, let question = data["q"]?.string, let endTime = data["endsAt"]?.int, let duration = data["duration"]?.int {
            var parsedAnswers = [String]()
            
            for answer in answers where answer.string != nil {
                parsedAnswers.append(answer.string!)
            }
            
            self.answers = parsedAnswers
            self.question = question
            self.endTime = Date(timeIntervalSinceReferenceDate: TimeInterval(endTime))
            self.duration = duration
            
            super.init(data: data)
        } else {
            return nil
        }
    }
}
