//
//  HandshakePacket.swift
//  Pods
//
//  Created by Jack Cook on 3/5/16.
//
//

/// A packet sent to initialize a handshake with tetris.
public class TetrisHandshakePacket: TetrisPacket, TetrisSendable {
    
    /// The id of the user being authenticated.
    public let id: Int?
    
    /// The authentication key required by tetris for authentication.
    public let key: String?
    
    /// Used when there is no locally authenticated user.
    public override init() {
        id = nil
        key = nil
    }
    
    /**
     Used when there is a locally authenticated user.
     
     :param: id The id of the user being authenticated.
     :param: key The authentication key required by tetris for authentication.
     */
    public init(id: Int, key: String) {
        self.id = id
        self.key = key
    }
    
    public var identifier: String {
        return "hshk"
    }
    
    public func data() -> [String: AnyObject] {
        var data = [String: AnyObject]()
        
        data["id"] = id ?? NSNull()
        data["key"] = key ?? NSNull()
        
        return data
    }
}
