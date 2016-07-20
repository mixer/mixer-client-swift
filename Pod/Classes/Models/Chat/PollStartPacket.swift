//
//  PollStartPacket.swift
//  Beam API
//
//  Created by Jack Cook on 5/26/15.
//  Copyright (c) 2016 Beam Interactive, Inc. All rights reserved.
//

import Foundation

/// A packet received when a poll has begun.
public class PollStartPacket: Packet {
    
    /// The options that can be chosen from.
    public let answers: [String]
    
    /// The poll's question.
    public let question: String
    
    /// The exact time at which the poll will end.
    public let endTime: NSDate
    
    /// The number of seconds that the poll will last for.
    public let duration: Int
    
    /**
     Used to initialize a poll start packet.
     
     :param: answers The answers that can be chosen from in the poll.
     :param: question The question being asked.
     :param: endTime The time at which the poll will end.
     :param: duration The number of seconds that the poll will last for.
     */
    public init(answers: [String], question: String, endTime: NSDate, duration: Int) {
        self.answers = answers
        self.question = question
        self.endTime = endTime
        self.duration = duration
    }
}
