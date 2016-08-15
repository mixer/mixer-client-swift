//
//  ChatPollStartPacket.swift
//  Beam API
//
//  Created by Jack Cook on 5/26/15.
//  Copyright (c) 2016 Beam Interactive, Inc. All rights reserved.
//

import SwiftyJSON

/// A packet received when a poll has begun.
public class ChatPollStartPacket: ChatPacket {
    
    /// The options that can be chosen from.
    public let answers: [String]
    
    /// The poll's question.
    public let question: String
    
    /// The exact time at which the poll will end.
    public let endTime: NSDate
    
    /// The number of seconds that the poll will last for.
    public let duration: Int
    
    /// Initializes a chat poll start packet with JSON data.
    override init?(data: [String: JSON]) {
        if let answers = data["answers"]?.array, question = data["q"]?.string, endTime = data["endsAt"]?.int, duration = data["duration"]?.int {
            var parsedAnswers = [String]()
            
            for answer in answers where answer.string != nil {
                parsedAnswers.append(answer.string!)
            }
            
            self.answers = parsedAnswers
            self.question = question
            self.endTime = NSDate(timeIntervalSinceReferenceDate: NSTimeInterval(endTime))
            self.duration = duration
            
            super.init(data: data)
        } else {
            return nil
        }
    }
}
