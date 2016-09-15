//
//  ChatPacket.swift
//  Beam API
//
//  Created by Jack Cook on 6/4/15.
//  Copyright (c) 2016 Beam Interactive, Inc. All rights reserved.
//

import SwiftyJSON

/// The base packet class. Also has methods used to receive and send packets.
public class ChatPacket {
    
    /// The string of the packet's raw data.
    fileprivate var packetString: String?
    
    /// Initializes an empty packet.
    init() {
    }
    
    /// Initializes a chat packet with a JSON dictionary.
    init?(data: [String: JSON]) {
    }
    
    /// Initializes a chat packet with a JSON array.
    init?(data: [JSON]) {
    }
    
    /**
     Creates a raw packet string from a packet object.
     
     :param: packet The packet being sent by the app.
     :param: count The nth packet sent by the app.
     :returns: The raw packet string to be sent to the chat servers.
     */
    class func prepareToSend(_ packet: ChatSendable, count: Int) -> String {
        let packet = [
            "type": "method",
            "method": packet.identifier,
            "arguments": packet.arguments(),
            "id": "\(count)"
        ] as [String : Any]
        
        return JSON(packet).rawString(String.Encoding.utf8, options: JSONSerialization.WritingOptions(rawValue: 0)) ?? ""
    }
    
    /**
     Interprets JSON packets received from the chat servers.
     
     :param: json The JSON object being interpreted.
     :returns: The packet object to be used by the app.
     */
    class func receivePacket(_ json: JSON) -> ChatPacket? {
        var packet: ChatPacket?
        
        if let event = json["event"].string, let data = json["data"].dictionary {
            switch event {
            case "ChatMessage":
                packet = ChatMessagePacket(data: data)
            case "DeleteMessage":
                packet = ChatDeleteMessagePacket(data: data)
            case "PollEnd":
                packet = ChatPollEndPacket(data: data)
            case "PollStart":
                packet = ChatPollStartPacket(data: data)
            case "UserJoin":
                packet = ChatUserJoinPacket(data: data)
            case "UserLeave":
                packet = ChatUserLeavePacket(data: data)
            case "UserUpdate":
                packet = ChatUserUpdatePacket(data: data)
            default:
                print("Unrecognized packet received: \(event) with parameters \(data)")
            }
        } else if let type = json["type"].string, let data = json["data"].array {
            switch type {
            case "reply":
                packet = ChatMessagesPacket(data: data)
            default:
                print("Unknown packet received: \(json)")
            }
        } else {
            print("Unknown packet received: \(json)")
        }
        
        return packet
    }
}
