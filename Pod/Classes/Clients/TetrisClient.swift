//
//  TetrisClient.swift
//  Pods
//
//  Created by Jack Cook on 3/5/16.
//
//

import Starscream
import SwiftyJSON

/// Used to connect to a channel's interactive controls through our tetris protocol.
public class TetrisClient: WebSocketDelegate {
    
    // MARK: Properties
    
    /// The client's delegate, through which control updates are relayed to your app.
    private weak var delegate: TetrisClientDelegate?
    
    /// The stored authentication key. Will only be generated if BeamSession.sharedSession != nil, and is needed to send control updates.
    private var authKey: String?
    
    /// The id of the channel being connected to.
    private var channelId: Int!
    
    /// The id of the authenticated user in the app.
    private var userId: Int?
    
    /// The current tetris control state.
    private var state: String?
    
    /// The websocket through which control updates are received and sent.
    private var socket: WebSocket?
    
    /// Initializes a tetris connection, which needs to be stored by your own class.
    public init(delegate tetrisDelegate: TetrisClientDelegate) {
        delegate = tetrisDelegate
    }
    
    // MARK: Public Methods
    
    /**
     Connects to a tetris channel given data that is received with TetrisRoutes.getTetrisDataByChannel
    
     :param: url The base URL of the tetris server being connected to.
     :param: channelId The id of the channel being connected to.
     :param: key The key used to authenticate with tetris.
     :param: userId The id of the authenticated user in the app.
     */
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
    
    /// Disconnects from the tetris server.
    public func disconnect() {
        self.socket?.disconnect()
    }
    
    /**
     Sends a packet to the tetris server.
     
     :param: packet The packet being sent.
     */
    public func sendPacket(packet: TetrisSendable) {
        guard let socket = socket else {
            return
        }
        
        let packetData = TetrisPacket.prepareToSend(packet)
        socket.writeString(packetData)
    }
    
    // MARK: Private Methods
    
    /// Called when the control state is changed by the broadcaster.
    private func updateState(state: String) {
        if state != self.state {
            self.state = state
            delegate?.tetrisChangedState(state)
        }
    }
    
    // MARK: WebSocketDelegate
    
    public func websocketDidConnect(socket: WebSocket) {
        delegate?.tetrisDidConnect()
        
        guard let authKey = authKey,
            userId = userId else {
                let packet = TetrisHandshakePacket()
                sendPacket(packet)
                
                return
        }
        
        let packet = TetrisHandshakePacket(id: userId, key: authKey)
        sendPacket(packet)
    }
    
    public func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        delegate?.tetrisDidDisconnect()
    }
    
    public func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        if let (packet, state) = TetrisPacket.receivePacket(text) {
            if let packet = packet {
                delegate?.tetrisReceivedPacket(packet)
            }
            
            if let state = state {
                updateState(state)
            }
        }
    }
    
    public func websocketDidReceiveData(socket: WebSocket, data: NSData) {
    }
}

/// The tetris client's delegate, through which information is relayed to your app.
public protocol TetrisClientDelegate: class {
    
    /// Called when a connection is made to the tetris server.
    func tetrisDidConnect()
    
    /// Called when the client disconnects, whether on purpose or due to an error.
    func tetrisDidDisconnect()
    
    /// Called when the control state is changed by the broadcaster.
    func tetrisChangedState(state: String)
    
    /// Called when a packet is received and interpreted.
    func tetrisReceivedPacket(packet: TetrisPacket)
}
