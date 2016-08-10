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
    
    /// The client's shared instance.
    public class var sharedClient: ConstellationClient {
        struct Static {
            static let instance = ConstellationClient()
        }
        return Static.instance
    }
    
    /// The client's delegate, through which updates are relayed to the app.
    private weak var delegate: ConstellationClientDelegate?
    
    /// The websocket through which constellation data is sent and received.
    private var socket: WebSocket?
    
    // MARK: Public Methods
    
    /// Makes a connection to constellation through a websocket.
    public func connect(delegate: ConstellationClientDelegate) {
        self.delegate = delegate
        
        socket = WebSocket(url: NSURL(string: "wss://constellation.beam.pro")!)
        socket?.delegate = self
        socket?.connect()
    }
    
    /// Disconnects from constellation.
    public func disconnect() {
        self.socket?.disconnect()
    }
    
    /**
     Sends a packet to constellation.
     
     :param: packet The packet to be sent.
     */
    public func sendPacket(packet: ConstellationSendable) {
        guard let socket = socket else {
            return
        }
        
        let packetData = ConstellationPacket.prepareToSend(packet)
        socket.writeString(packetData)
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
