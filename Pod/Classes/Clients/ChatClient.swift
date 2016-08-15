//
//  ChatClient.swift
//  Beam
//
//  Created by Jack Cook on 1/8/16.
//  Copyright © 2016 MCProHosting. All rights reserved.
//

import Starscream
import SwiftyJSON

/// Used to connect to and communicate with a Beam chat server. There is no shared session, meaning several chat connections can be made at once.
public class ChatClient: WebSocketDelegate {
    
    // MARK: Properties
    
    /// The client's delegate, through which updates and chat messages are relayed to your app.
    private weak var delegate: ChatClientDelegate?
    
    /// The stored authentication key. Will only be generated if BeamSession.sharedSession != nil, and is needed to send chat messages.
    private var authKey: String?
    
    /// The id of the channel being connected to.
    private var channelId: Int!
    
    /// The number of the packet being sent.
    private var packetCount = 0
    
    /// The websocket through which chat data is received and sent.
    private var socket: WebSocket?
    
    /// Initializes a chat connection, which needs to be stored by your own class.
    public init(delegate chatDelegate: ChatClientDelegate) {
        delegate = chatDelegate
    }
    
    // MARK: Public Methods
    
    /**
     Requests chat details and uses them to connect to a channel.
    
     :param: channelId The id of the channel being connected to.
     */
    public func joinChannel(channelId: Int) {
        self.channelId = channelId
        
        BeamClient.sharedClient.chat.getChatDetailsById(channelId) { (endpoints, authKey, error) in
            guard let endpoints = endpoints else {
                print("channel details did not return endpoints or authkey")
                return
            }
            
            if let authKey = authKey {
                self.authKey = authKey
            }
            
            if let url = NSURL(string: endpoints[0]) {
                self.socket = WebSocket(url: url, protocols: ["chat", "http-only"])
                self.socket?.delegate = self
                self.socket?.connect()
            }
        }
    }
    
    /// Disconnects from the chat server.
    public func disconnect() {
        self.socket?.disconnect()
    }
    
    /**
     Sends a packet to the chat server.
     
     :param: packet The packet being sent.
     */
    public func sendPacket(packet: Sendable) {
        packetCount += 1
        
        guard let socket = socket else {
            return
        }
        
        let packetData = Packet.prepareToSend(packet, count: packetCount)
        socket.writeString(packetData)
    }
    
    // MARK: WebSocketDelegate
    
    public func websocketDidConnect(socket: WebSocket) {
        guard let userId = BeamSession.sharedSession?.user.id,
            authKey = authKey else {
                let packet = AuthenticatePacket(channelId: channelId)
                sendPacket(packet)
                
                delegate?.chatDidConnect()
                
                return
        }
        
        delegate?.chatDidConnect()
        
        let packet = AuthenticatePacket(channelId: channelId, userId: userId, authKey: authKey)
        sendPacket(packet)
    }
    
    public func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
    }
    
    public func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        guard let data = text.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) else {
            print("unknown error parsing chat packet")
            return
        }
        
        do {
            if let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSDictionary {
                let json = JSON(jsonObject)
                
                if let packet = Packet.receivePacket(json) {
                    self.delegate?.chatReceivedPacket(packet)
                }
            }
        } catch { }
    }
    
    public func websocketDidReceiveData(socket: WebSocket, data: NSData) {
    }
}

/// The chat client's delegate, through which information is relayed to your app.
public protocol ChatClientDelegate: class {
    
    /// Called when a connection is made to the chat server.
    func chatDidConnect()
    
    /// Called when a packet is received and interpreted.
    func chatReceivedPacket(packet: Packet)
}
