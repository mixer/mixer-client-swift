//
//  DeleteMessagePacket.swift
//  Beam API
//
//  Created by Jack Cook on 6/29/15.
//  Copyright (c) 2015 MCProHosting. All rights reserved.
//

public class DeleteMessagePacket: Packet {
    
    public var id: String!
    
    public init(id: String) {
        self.id = id
    }
}
