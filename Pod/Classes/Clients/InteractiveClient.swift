//
//  InteractiveClient.swift
//  Pods
//
//  Created by Jack Cook on 3/5/16.
//
//

import Starscream
import SwiftyJSON

/// Used to connect to a channel's interactive controls through our interactive protocol.
public class InteractiveClient: WebSocketDelegate {
    
    // MARK: Properties
    
    /// The client's delegate, through which control updates are relayed to your app.
    fileprivate weak var delegate: InteractiveClientDelegate?
    
    /// The stored authentication key. Will only be generated if BeamSession.sharedSession != nil, and is needed to send control updates.
    fileprivate var authKey: String?
    
    /// The id of the channel being connected to.
    fileprivate var channelId: Int!
    
    /// The id of the authenticated user in the app.
    fileprivate var userId: Int?
    
    /// The current interactive control state.
    fileprivate var state: String?
    
    /// The websocket through which control updates are received and sent.
    fileprivate var socket: WebSocket?
    
    /// Initializes an interactive connection, which needs to be stored by your own class.
    public init(delegate interactiveDelegate: InteractiveClientDelegate) {
        delegate = interactiveDelegate
    }
    
    // MARK: Public Methods
    
    /**
     Connects to an interactive channel given data that is received with InteractiveRoutes.getInteractiveDataByChannel
    
     :param: url The base URL of the interactive server being connected to.
     :param: channelId The id of the channel being connected to.
     :param: key The key used to authenticate with interactive.
     :param: userId The id of the authenticated user in the app.
     */
    public func connect(url baseUrl: String, channelId: Int, key: String? = nil, userId: Int? = nil) {
        authKey = key
        self.channelId = channelId
        self.userId = userId ?? BeamSession.sharedSession?.user.id
        
        guard let url = URL(string: "\(baseUrl)/play/\(channelId)") else {
            return
        }
        
        socket = WebSocket(url: url, protocols: ["chat", "http-only"])
        socket?.delegate = self
        socket?.connect()
    }
    
    /// Disconnects from the interactive server.
    public func disconnect() {
        self.socket?.disconnect()
    }
    
    /**
     Sends a packet to the interactive server.
     
     :param: packet The packet being sent.
     */
    public func sendPacket(_ packet: InteractiveSendable) {
        guard let socket = socket else {
            return
        }
        
        let packetData = InteractivePacket.prepareToSend(packet)
        socket.write(string: packetData)
    }
    
    // MARK: Private Methods
    
    /// Called when the control state is changed by the broadcaster.
    fileprivate func updateState(_ state: String) {
        if state != self.state {
            self.state = state
            delegate?.interactiveChangedState(state)
        }
    }
    
    // MARK: WebSocketDelegate
    
    public func websocketDidConnect(socket: WebSocket) {
        delegate?.interactiveDidConnect()
        
        guard let authKey = authKey,
            let userId = userId else {
                let packet = InteractiveHandshakePacket()
                sendPacket(packet)
                
                return
        }
        
        let packet = InteractiveHandshakePacket(id: userId, key: authKey)
        sendPacket(packet)
    }
    
    public func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        delegate?.interactiveDidDisconnect()
    }
    
    public func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        if let (packet, state) = InteractivePacket.receivePacket(text) {
            if let packet = packet {
                delegate?.interactiveReceivedPacket(packet)
            }
            
            if let state = state {
                updateState(state)
            }
        }
    }
    
    public func websocketDidReceiveData(socket: WebSocket, data: Data) {
    }
}

/// The interactive client's delegate, through which information is relayed to your app.
public protocol InteractiveClientDelegate: class {
    
    /// Called when a connection is made to the interactive server.
    func interactiveDidConnect()
    
    /// Called when the client disconnects, whether on purpose or due to an error.
    func interactiveDidDisconnect()
    
    /// Called when the control state is changed by the broadcaster.
    func interactiveChangedState(_ state: String)
    
    /// Called when a packet is received and interpreted.
    func interactiveReceivedPacket(_ packet: InteractivePacket)
}
