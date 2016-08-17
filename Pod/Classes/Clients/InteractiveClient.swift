//
//  InteractiveClient.swift
//  Pods
//
//  Created by Jack Cook on 3/5/16.
//
//

import Starscream
import SwiftyJSON

/// Used to connect to a channel's interactive controls through our Interactive protocol.
public class InteractiveClient: WebSocketDelegate {
    
    // MARK: Properties
    
    /// The client's delegate, through which control updates are relayed to your app.
    private weak var delegate: InteractiveClientDelegate?
    
    /// The stored authentication key. Will only be generated if BeamSession.sharedSession != nil, and is needed to send control updates.
    private var authKey: String?
    
    /// The id of the channel being connected to.
    private var channelId: Int!
    
    /// The id of the authenticated user in the app.
    private var userId: Int?
    
    /// The current Interactive control state.
    private var state: String?
    
    /// The websocket through which control updates are received and sent.
    private var socket: WebSocket?
    
    /// Initializes a Interactive connection, which needs to be stored by your own class.
    public init(delegate InteractiveDelegate: InteractiveClientDelegate) {
        delegate = InteractiveDelegate
    }
    
    // MARK: Public Methods
    
    /**
     Connects to a Interactive channel given data that is received with InteractiveRoutes.getInteractiveDataByChannel
    
     :param: url The base URL of the Interactive server being connected to.
     :param: channelId The id of the channel being connected to.
     :param: key The key used to authenticate with Interactive.
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
    
    /// Disconnects from the Interactive server.
    public func disconnect() {
        self.socket?.disconnect()
    }
    
    /**
     Sends a packet to the Interactive server.
     
     :param: packet The packet being sent.
     */
    public func sendPacket(packet: InteractiveSendable) {
        guard let socket = socket else {
            return
        }
        
        let packetData = InteractivePacket.prepareToSend(packet)
        socket.writeString(packetData)
    }
    
    // MARK: Private Methods
    
    /// Called when the control state is changed by the broadcaster.
    private func updateState(state: String) {
        if state != self.state {
            self.state = state
            delegate?.InteractiveChangedState(state)
        }
    }
    
    // MARK: WebSocketDelegate
    
    public func websocketDidConnect(socket: WebSocket) {
        delegate?.InteractiveDidConnect()
        
        guard let authKey = authKey,
            userId = userId else {
                let packet = InteractiveHandshakePacket()
                sendPacket(packet)
                
                return
        }
        
        let packet = InteractiveHandshakePacket(id: userId, key: authKey)
        sendPacket(packet)
    }
    
    public func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        delegate?.InteractiveDidDisconnect()
    }
    
    public func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        if let (packet, state) = InteractivePacket.receivePacket(text) {
            if let packet = packet {
                delegate?.InteractiveReceivedPacket(packet)
            }
            
            if let state = state {
                updateState(state)
            }
        }
    }
    
    public func websocketDidReceiveData(socket: WebSocket, data: NSData) {
    }
}

/// The Interactive client's delegate, through which information is relayed to your app.
public protocol InteractiveClientDelegate: class {
    
    /// Called when a connection is made to the Interactive server.
    func InteractiveDidConnect()
    
    /// Called when the client disconnects, whether on purpose or due to an error.
    func InteractiveDidDisconnect()
    
    /// Called when the control state is changed by the broadcaster.
    func InteractiveChangedState(state: String)
    
    /// Called when a packet is received and interpreted.
    func InteractiveReceivedPacket(packet: InteractivePacket)
}
