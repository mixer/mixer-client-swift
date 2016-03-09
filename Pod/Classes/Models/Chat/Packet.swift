//
//  Packet.swift
//  Beam API
//
//  Created by Jack Cook on 6/4/15.
//  Copyright (c) 2015 MCProHosting. All rights reserved.
//

import SwiftyJSON

public class Packet {
    
    private var packetString: String?
    
    class func prepareToSend(packet: Sendable) -> String {
        let method = packet.identifier
        let arguments = packet.arguments()
        
        var argumentString = ""
        
        for arg in arguments {
            if arg is String {
                argumentString += "\"\(arg)\","
            } else {
                argumentString += "\(arg),"
            }
        }
        
        argumentString = argumentString.substringToIndex(argumentString.endIndex.predecessor())
        
        let packetString = "{\"type\":\"method\",\"method\":\"\(method)\",\"arguments\":[\(argumentString)],\"id\":1}"
        
        return packetString
    }
    
    class func receivePacket(json: JSON) -> Packet? {
        var packet: Packet?
        
        if let event = json["event"].string {
            if let data = json["data"].dictionaryObject {
                switch event {
                case "ChatMessage":
                    let message = BeamMessage(json: JSON(data))
                    packet = MessagePacket(message: message)
                case "DeleteMessage":
                    if let id = data["id"] as? String {
                        packet = DeleteMessagePacket(id: id)
                    }
                case "PollEnd":
                    if let voters = data["voters"] as? Int {
                        if let responses = data["responses"] as? [String: Int] {
                            packet = PollEndPacket(voters: voters, responses: responses)
                        }
                    }
                case "PollStart":
                    if let answers = data["answers"] as? [String] {
                        if let question = data["q"] as? String {
                            if let endTime = data["endsAt"] as? Int {
                                if let duration = data["duration"] as? Int {
                                    let endDate = NSDate(timeIntervalSinceReferenceDate: NSTimeInterval(endTime))
                                    packet = PollStartPacket(answers: answers, question: question, endTime: endDate, duration: duration)
                                }
                            }
                        }
                    }
                case "UserJoin", "UserLeave":
                    if let username = data["username"] as? String {
                        if let roles = data["roles"] as? [String] {
                            if let userId = data["id"] as? Int {
                                if event == "UserJoin" {
                                    packet = UserJoinPacket(username: username, roles: roles, userId: userId)
                                } else if event == "UserLeave" {
                                    packet = UserLeavePacket(username: username, roles: roles, userId: userId)
                                }
                            }
                        }
                    }
                case "UserUpdate":
                    if let permissions = data["permissions"] as? [String] {
                        if let userId = data["user"] as? Int {
                            if let username = data["username"] as? String {
                                if let roles = data["roles"] as? [String] {
                                    packet = UserUpdatePacket(permissions: permissions, userId: userId, username: username, roles: roles)
                                }
                            }
                        }
                    }
                default:
                    print("Unrecognized packet received: \(event) with parameters \(data)")
                }
            }
        } else if let type = json["type"].string {
            switch type {
            case "reply":
                if let data = json["data"].arrayObject {
                    var packets = [MessagePacket]()
                    for datum in data {
                        let message = BeamMessage(json: JSON(datum))
                        let messagePacket = MessagePacket(message: message)
                        packets.append(messagePacket)
                    }
                    
                    let packet = MessagesPacket(packets: packets)
                    return packet
                }
            default:
                print("Unknown packet received: \(json)")
            }
        } else {
            print("Unknown packet received: \(json)")
        }
        
        return packet
    }
}
