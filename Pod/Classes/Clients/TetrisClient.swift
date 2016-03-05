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
    private var userId: Int?
    
    private var socket: WebSocket?
    
    public init(delegate tetrisDelegate: TetrisClientDelegate) {
        delegate = tetrisDelegate
    }
    
    // MARK: Public Methods
    
    public func connect(url baseUrl: String, channelId: Int, key: String? = nil, userId: Int? = nil) {
        authKey = key
        self.channelId = channelId
        self.userId = userId ?? BeamSession.sharedSession?.user.id
        
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
    
    public func sendPacket(packet: TetrisSendable) {
        guard let socket = socket else {
            return
        }
        
        let packetData = TetrisPacket.prepareToSend(packet)
        socket.writeString(packetData)
    }
    
    // MARK: WebSocketDelegate
    
    public func websocketDidConnect(socket: WebSocket) {
        delegate?.tetrisDidConnect()
        
        guard let authKey = authKey,
            userId = userId else {
                let packet = HandshakePacket()
                sendPacket(packet)
                
                return
        }
        
        let packet = HandshakePacket(id: userId, key: authKey)
        sendPacket(packet)
    }
    
    public func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
    }
    
    public func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        if let packet = TetrisPacket.receivePacket(text) {
            delegate?.tetrisReceivedPacket(packet)
        }
    }
    
    public func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        print("received data")
    }
}

public protocol TetrisClientDelegate: class {
    func tetrisDidConnect()
    func tetrisReceivedPacket(packet: TetrisPacket)
}
