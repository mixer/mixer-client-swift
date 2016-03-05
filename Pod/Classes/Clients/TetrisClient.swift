//
//  TetrisClient.swift
//  Pods
//
//  Created by Jack Cook on 3/5/16.
//
//

import Starscream
import SwiftyJSON

public class TetrisClient: WebSocketDelegate {
    
    // MARK: Properties
    
    private weak var delegate: TetrisClientDelegate?
    
    private var authKey: String?
    private var channelId: Int!
    
    private var socket: WebSocket?
    
    public init(delegate tetrisDelegate: TetrisClientDelegate) {
        delegate = tetrisDelegate
    }
    
    // MARK: Public Methods
    
    public func connectToChannel(url baseUrl: String, key: String, channelId: Int) {
        authKey = key
        self.channelId = channelId
        
        guard let url = NSURL(string: "\(baseUrl)/play/\(channelId)") else {
            return
        }
        
        socket = WebSocket(url: url, protocols: ["chat", "http-only"])
        socket?.delegate = self
        socket?.connect()
    }
    
    public func disconnect() {
        self.socket?.disconnect()
    }
    
    public func sendPacket(packet: Sendable) {
        guard let socket = socket else {
            return
        }
        
        let packetData = Packet.prepareToSend(packet)
        socket.writeString(packetData)
    }
    
    // MARK: WebSocketDelegate
    
    public func websocketDidConnect(socket: WebSocket) {
        guard let authKey = authKey else {
            print("no auth key")
            return
        }
        
        let key = "fqyyctjl9tp0kknh"
        let packet = "hshk{\"id\":5386,\"key\":\"\(key)\"}"
        print(packet)
        
        socket.writeString(packet)
    }
    
    public func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
    }
    
    public func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        guard let data = text.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) else {
            print("unknown error parsing tetris packet")
            return
        }
        
        print(text)
        
        do {
            if let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSDictionary {
                let json = JSON(jsonObject)
                
//                if let packet = Packet.receivePacket(json) {
//                    self.delegate?.receivedPacket(packet)
//                }
            }
        } catch { }
    }
    
    public func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        print("received data")
    }
}

public protocol TetrisClientDelegate: class {
//    func didConnect()
//    func receivedPacket(packet: Packet)
//    func updateWithViewers(viewers: Int)
}
