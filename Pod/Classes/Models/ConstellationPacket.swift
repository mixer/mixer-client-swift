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
                    case "live":
                        if let channel = data["channel"]?.string {
                            let channelData = channel.componentsSeparatedByString(":")
                            switch (channelData[0], channelData[2]) {
                            case ("channel", "followed"):
                                packet = ConstellationChannelFollowedPacket(data: data)
                            case ("channel", "hosted"):
                                packet = ConstellationChannelHostedPacket(data: data)
                            case ("channel", "subscribed"):
                                break
                            case ("channel", "resubscribed"):
                                break
                            case ("channel", "update"):
                                break
                            case ("interactive", "connect"):
                                break
                            case ("team", "deleted"):
                                break
                            case ("team", "memberAccepted"):
                                break
                            case ("team", "memberInvited"):
                                break
                            case ("team", "memberRemoved"):
                                break
                            case ("team", "ownerChanged"):
                                break
                            case ("user", "achievement"):
                                break
                            case ("user", "followed"):
                                break
                            case ("user", "notify"):
                                break
                            case ("user", "subscribed"):
                                break
                            case ("user", "resubscrbed"):
                                break
                            case ("user", "teamAccepted"):
                                break
                            case ("user", "teamInvited"):
                                break
                            case ("user", "teamRemoved"):
                                break
                            case ("user", "update"):
                                break
                            default:
                                packet = ConstellationLivePacket(data: data)
                            }
                        }
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
