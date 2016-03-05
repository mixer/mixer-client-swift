//
//  ErrorPacket.swift
//  Pods
//
//  Created by Jack Cook on 3/5/16.
//
//

public class ErrorPacket: TetrisPacket {
    
    public let message: String
    
    public init(message: String) {
        self.message = message
    }
}
