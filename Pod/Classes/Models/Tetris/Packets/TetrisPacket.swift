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
        case "hshk": // 2
            if let id = data["id"].int,
                key = data["key"].string {
                    packet = HandshakePacket(id: id, key: key)
            }
        case "hack": // 1
            if let state = data["state"].string {
                packet = HandshakeAcknowledgmentPacket(state: state)
            }
     // case "data": // 2
        case "erro": // 3
            if let message = data["message"].string {
                packet = ErrorPacket(message: message)
            }
        case "prog": // 4
            var controls = [ProgressPacketControl]()
            
            if let tactiles = data["tactile"].array {
                for tactile in tactiles {
                    if let id = tactile["id"].int,
                        cooldown = tactile["cooldown"].int,
                        progress = tactile["progress"].int,
                        disabled = tactile["disabled"].bool {
                            let control = ProgressPacketTactile(id: id, fired: tactile["fired"].bool ?? false, cooldown: cooldown, progress: progress, disabled: disabled)
                            controls.append(control)
                    }
                }
            }
            
            if let joysticks = data["joystick"].array {
                for joystick in joysticks {
                    if let id = joystick["id"].int,
                        angle = joystick["angle"].float,
                        intensity = joystick["intensity"].float {
                            let control = ProgressPacketJoystick(id: id, angle: angle, intensity: intensity)
                            controls.append(control)
                    }
                }
            }
            
            packet = ProgressPacket(controls: controls)
        default:
            print("Unrecognized packet received: \(event) with data \(dataString)")
        }
        
        if let state = data["state"].string {
            return (packet, state)
        } else {
            return (packet, nil)
        }
    }
}
