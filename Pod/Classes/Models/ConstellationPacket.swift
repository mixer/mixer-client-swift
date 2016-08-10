//
//  ConstellationPacket.swift
//  Pods
//
//  Created by Jack Cook on 8/10/16.
//
//

import SwiftyJSON

/// The base constellation packet class. Also has methods used to send and receive packets.
public class ConstellationPacket {
    
    /// The string of the packet's raw JSON data.
    private var packetString: String?
    
    /**
     Interprets JSON packets received from the constellation servers.
     
     :param: json The JSON object being interpreted.
     :returns: The constellation packet object to be used by the app.
     */
    class func receivePacket(json: JSON) -> ConstellationPacket? {
        var packet: ConstellationPacket?
        
        if let type = json["type"].string {
            switch type {
            case "event":
                if let event = json["event"].string, data = json["data"].dictionary {
                    switch event {
                    case "hello":
                        packet = ConstellationHelloPacket(data: data)
                    default:
                        print("Unrecognized constellation event packet received: \(json)")
                    }
                }
            default:
                print("Unrecognized constellation packet received: \(json)")
            }
        } else {
            print("Unknown constellation packet received: \(json)")
        }
        
        return packet
    }
}
