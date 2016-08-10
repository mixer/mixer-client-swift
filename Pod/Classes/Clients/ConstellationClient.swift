//
//  ConstellationClient.swift
//  Pods
//
//  Created by Jack Cook on 8/10/16.
//
//

import Starscream
import SwiftyJSON

/// Used to connect to and communicate with Beam's liveloading socket.
public class ConstellationClient: WebSocketDelegate {
    
    // MARK: Properties
    
    /// The client's delegate, through which updates are relayed to the app.
    private weak var delegate: ConstellationClientDelegate?
    
    /// The websocket through which constellation data is sent and received.
    private var socket: WebSocket?
    
    // MARK: Initializers
    
    /// Initializes a constellation client with a delegate.
    public init(delegate constellationDelegate: ConstellationClientDelegate) {
        delegate = constellationDelegate
    }
    
    // MARK: Public Methods
    
    /// Makes a connection to constellation through a websocket.
    public func connect() {
        socket = WebSocket(url: NSURL(string: "wss://constellation.beam.pro")!)
        socket?.delegate = self
        socket?.connect()
    }
    
    // MARK: WebSocketDelegate Methods
    
    public func websocketDidConnect(socket: WebSocket) {
        delegate?.constellationDidConnect()
    }
    
    public func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        delegate?.constellationDidDisconnect(error)
    }
    
    public func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        guard let data = text.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) else {
            print("unknown error parsing constellation packet: \(text)")
            return
        }
        
        do {
            if let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSDictionary {
                let json = JSON(jsonObject)
                
                if let packet = ConstellationPacket.receivePacket(json) {
                    self.delegate?.constellationReceivedPacket(packet)
                }
            }
        } catch {
            print("JSON read failure while parsing constellation packet: \(text)")
        }
    }
    
    public func websocketDidReceiveData(socket: WebSocket, data: NSData) {
    }
}

/// The constellation client's delegate, through which information is relayed to the app.
public protocol ConstellationClientDelegate: class {
    
    /// Called when a connection is made to the constellation server.
    func constellationDidConnect()
    
    /// Called when the websocket disconnects, whether on purpose or unexpectedly.
    func constellationDidDisconnect(error: NSError?)
    
    /// Called when a packet has been received and interpreted.
    func constellationReceivedPacket(packet: ConstellationPacket)
}
