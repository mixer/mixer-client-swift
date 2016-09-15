//
//  InteractivePacket.swift
//  Pods
//
//  Created by Jack Cook on 3/5/16.
//
//

import SwiftyJSON

/// The base interactive packet class. Also has methods used to send and receive interactive packets.
public class InteractivePacket {
    
    /// The string of the packet's raw data.
    fileprivate var packetString: String?
    
    /// Initializes an empty packet.
    init() {
    }
    
    /// Initializes an interactive packet with a JSON dictionary.
    init?(data: JSON) {
    }
    
    /**
     Creates a raw packet string from an interactive packet object.
     
     :param: packet The packet being sent by the app.
     :returns: The raw packet string to be sent to the interactive servers.
     */
    class func prepareToSend(_ packet: InteractiveSendable) -> String {
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
                dataString += "\"\(datum.0)\":[\(array.joined(separator: ","))],"
            } else {
                dataString += "\"\(datum.0)\":\(datum.1),"
            }
        }
        
        if dataString.characters.count > 0 {
            dataString = dataString.substring(to: dataString.characters.index(before: dataString.endIndex))
            
            let packetString = "\(method){\(dataString)}"
            return packetString
        } else {
            return "\(dataString){}"
        }
    }
    
    /**
     Interprets JSON packets received from the interactive servers.
     
     :param: string The string being interpreted.
     :returns: A tuple with the interactive packet and the current control state, if it has been updated.
     */
    class func receivePacket(_ string: String) -> (packet: InteractivePacket?, state: String?)? {
        var packet: InteractivePacket?
        
        let event = (string as NSString).substring(to: 4)
        let dataString = (string as NSString).replacingCharacters(in: NSMakeRange(0, 4), with: "")
        
        guard let actualData = dataString.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        let data = JSON(data: actualData)
        
        switch event {
        case "hack": // 1
            packet = InteractiveHandshakeAcknowledgmentPacket(data: data)
    
        case "erro": // 3
            packet = InteractiveErrorPacket(data: data)
        case "prog": // 4
            packet = InteractiveProgressPacket(data: data)
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
