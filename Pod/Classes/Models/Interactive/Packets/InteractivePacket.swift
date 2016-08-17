//
//  InteractivePacket.swift
//  Pods
//
//  Created by Jack Cook on 3/5/16.
//
//

import SwiftyJSON

/// The base Interactive packet class. Also has methods used to send and receive Interactive packets.
public class InteractivePacket {
    
    /// The string of the packet's raw data.
    private var packetString: String?
    
    /// Initializes an empty packet.
    init() {
    }
    
    /// Initializes a Interactive packet with a JSON dictionary.
    init?(data: JSON) {
    }
    
    /**
     Creates a raw packet string from a Interactive packet object.
     
     :param: packet The packet being sent by the app.
     :returns: The raw packet string to be sent to the Interactive servers.
     */
    class func prepareToSend(packet: InteractiveSendable) -> String {
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
     Interprets JSON packets received from the Interactive servers.
     
     :param: string The string being interpreted.
     :returns: A tuple with the Interactive packet and the current control state, if it has been updated.
     */
    class func receivePacket(string: String) -> (packet: InteractivePacket?, state: String?)? {
        var packet: InteractivePacket?
        
        let event = (string as NSString).substringToIndex(4)
        let dataString = (string as NSString).stringByReplacingCharactersInRange(NSMakeRange(0, 4), withString: "")
        
        guard let actualData = dataString.dataUsingEncoding(NSUTF8StringEncoding) else {
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
