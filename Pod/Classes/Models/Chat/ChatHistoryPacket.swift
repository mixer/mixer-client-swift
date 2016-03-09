//
//  ChatHistoryPacket.swift
//  Pods
//
//  Created by Jack Cook on 3/9/16.
//
//

public class ChatHistoryPacket: Packet, Sendable {
    
    public var quantity: Int
    
    public init(quantity: Int) {
        self.quantity = quantity
    }
    
    public var identifier: String {
        return "history"
    }
    
    public func arguments() -> [AnyObject] {
        return [quantity]
    }
}
