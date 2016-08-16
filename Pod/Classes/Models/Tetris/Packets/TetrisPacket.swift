//
//  TetrisPacket.swift
//  Pods
//
//  Created by Jack Cook on 3/5/16.
//
//

import SwiftyJSON

/// The base tetris packet class. Also has methods used to send and receive tetris packets.
public class TetrisPacket {
    
    /// The string of the packet's raw data.
    private var packetString: String?
    
    /// Initializes an empty packet.
    init() {
    }
    
    /// Initializes a tetris packet with a JSON dictionary.
    init?(data: JSON) {
    }
    
    /**
     Creates a raw packet string from a tetris packet object.
     
     :param: packet The packet being sent by the app.
     :returns: The raw packet string to be sent to the tetris servers.
     */
    class func prepareToSend(packet: TetrisSendable) -> String {
        let method = packet.identifier
        let data = packet.data()
        
        var dataString = ""
        
        for datum in data {
            if datum.1 is String {
                dataString += "\"\(datum.0)\":\"\(datum.1)\","
            } else if datum.1 is NSNull {
                dataString += "\"\(datum.0)\":null,"
            } else if datum.1 is [String] {
                let array = datum.1 as! [String]
                dataString += "\"\(datum.0)\":[\(array.joinWithSeparator(","))],"
            } else {
                dataString += "\"\(datum.0)\":\(datum.1),"
            }
        }
        
        if dataString.characters.count > 0 {
            dataString = dataString.substringToIndex(dataString.endIndex.predecessor())
            
            let packetString = "\(method){\(dataString)}"
            return packetString
        } else {
            return "\(dataString){}"
        }
    }
    
    /**
     Interprets JSON packets received from the tetris servers.
     
     :param: string The string being interpreted.
     :returns: A tuple with the tetris packet and the current control state, if it has been updated.
     */
    class func receivePacket(string: String) -> (packet: TetrisPacket?, state: String?)? {
        var packet: TetrisPacket?
        
        let event = (string as NSString).substringToIndex(4)
        let dataString = (string as NSString).stringByReplacingCharactersInRange(NSMakeRange(0, 4), withString: "")
        
        guard let actualData = dataString.dataUsingEncoding(NSUTF8StringEncoding) else {
            return nil
        }
        
        let data = JSON(data: actualData)
        
        switch event {
        case "hack": // 1
            packet = TetrisHandshakeAcknowledgmentPacket(data: data)
    
        case "erro": // 3
            packet = TetrisErrorPacket(data: data)
        case "prog": // 4
            packet = TetrisProgressPacket(data: data)
        default:
            print("Unrecognized packet received: \(event) with data \(dataString)")
        }
        
        if packet == nil {
            print("Unrecognized packet received: \(event) with data \(dataString)")
        }
        
        if let state = data["state"].string {
            return (packet, state)
        } else {
            return (packet, nil)
        }
    }
}
