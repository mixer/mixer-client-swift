//
//  PollEndPacket.swift
//  Beam API
//
//  Created by Jack Cook on 5/26/15.
//  Copyright (c) 2015 MCProHosting. All rights reserved.
//

public class PollEndPacket: Packet {
    
    public let voters: Int?
    public let responses: [String: Int]?
    
    public init(voters: Int, responses: [String: Int]) {
        self.voters = voters
        self.responses = responses
    }
}
