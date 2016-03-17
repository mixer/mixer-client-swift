//
//  ChatClient.swift
//  Beam
//
//  Created by Jack Cook on 1/8/16.
//  Copyright © 2016 MCProHosting. All rights reserved.
//

import Starscream
import SwiftyJSON

public class ChatClient: WebSocketDelegate {
    
    // MARK: Properties
    
    private weak var delegate: ChatClientDelegate?
    
    private var authKey: String?
    private var channelId: Int!
    private var packetCount = 0
    
    private var socket: WebSocket?
    private var timer: NSTimer!
    
    public init(delegate chatDelegate: ChatClientDelegate) {
        delegate = chatDelegate
    }
    
    // MARK: Public Methods
    
    public func joinChannel(channelId: Int) {
        self.channelId = channelId
        
        BeamClient.sharedClient.chat.getChatDetailsById(channelId) { (endpoints, authKey, error) -> Void in
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
        
        timer = NSTimer(timeInterval: 10, target: self, selector: "updateData", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
    }
    
    public func disconnect() {
        self.socket?.disconnect()
        self.timer?.invalidate()
    }
    
    public func sendPacket(packet: Sendable) {
        packetCount += 1
        
        guard let socket = socket else {
            return
        }
        
        let packetData = Packet.prepareToSend(packet, count: packetCount)
        socket.writeString(packetData)
    }
    
    // MARK: Private Methods
    
    @objc private func updateData() {
        BeamClient.sharedClient.channels.getChannelWithId(self.channelId, completion: { (channel, error) -> Void in
            guard let channel = channel else {
                return
            }
            
            self.delegate?.updateWithViewers(channel.viewersCurrent)
        })
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

public protocol ChatClientDelegate: class {
    func chatDidConnect()
    func chatReceivedPacket(packet: Packet)
    func updateWithViewers(viewers: Int)
}
