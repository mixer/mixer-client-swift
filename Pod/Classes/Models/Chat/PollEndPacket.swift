//
//  PollEndPacket.swift
//  Beam API
//
//  Created by Jack Cook on 5/26/15.
//  Copyright (c) 2015 MCProHosting. All rights reserved.
//

/// A packet received when a poll has ended.
public class PollEndPacket: Packet {
    
    /// The number of people who voted in the poll.
    public let voters: Int
    
    /// The responses made by poll voters.
    public let responses: [String: Int]
    
    /**
     Used to initialize a poll end packet.
     
     :param: voters The number of people who voted in the poll.
     :param: responses The responses made by poll voters.
     */
    init(voters: Int, responses: [String: Int]) {
        self.voters = voters
        self.responses = responses
    }
}
