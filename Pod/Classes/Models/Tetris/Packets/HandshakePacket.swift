//
//  HandshakePacket.swift
//  Pods
//
//  Created by Jack Cook on 3/5/16.
//
//

public class HandshakePacket: TetrisPacket, TetrisSendable {
    
    public let id: Int?
    public let key: String?
    
    public override init() {
        id = nil
        key = nil
    }
    
    public init(id: Int, key: String) {
        self.id = id
        self.key = key
    }
    
    public var identifier: String {
        return "hshk"
    }
    
    public func data() -> [String: AnyObject?] {
        var data = [String: AnyObject?]()
        
        data["id"] = id ?? NSNull()
        data["key"] = key ?? NSNull()
        
        return data
    }
}
