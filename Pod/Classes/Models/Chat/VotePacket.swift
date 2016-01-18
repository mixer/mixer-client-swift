//
//  VotePacket.swift
//  Beam API
//
//  Created by Jack Cook on 5/26/15.
//  Copyright (c) 2015 MCProHosting. All rights reserved.
//

public class VotePacket: Packet, Sendable {
    
    public let option: Int?
    
    public init(option: Int) {
        self.option = option
    }
    
    public var identifier: String {
        return "vote"
    }
    
    public func arguments() -> [AnyObject] {
        var objects = [AnyObject]()
        
        if let option = option {
            objects.append(option)
        }
        
        return objects
    }
}
