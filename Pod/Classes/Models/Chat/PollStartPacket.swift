//
//  PollStartPacket.swift
//  Beam API
//
//  Created by Jack Cook on 5/26/15.
//  Copyright (c) 2015 MCProHosting. All rights reserved.
//

import Foundation

public class PollStartPacket: Packet {
    
    public let answers: [String]?
    public let question: String?
    public let endTime: NSDate?
    public let duration: Int?
    
    public init(answers: [String], question: String, endTime: NSDate, duration: Int) {
        self.answers = answers
        self.question = question
        self.endTime = endTime
        self.duration = duration
    }
}
