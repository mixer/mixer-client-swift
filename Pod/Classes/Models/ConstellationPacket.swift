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
                                packet = ConstellationChannelSubscribedPacket(data: data)
                            case ("channel", "resubscribed"):
                                packet = ConstellationChannelResubscribedPacket(data: data)
                            case ("channel", "update"):
                                packet = ConstellationChannelUpdatePacket(data: data)
                            case ("team", "deleted"):
                                packet = ConstellationTeamDeletedPacket(data: data)
                            case ("team", "memberAccepted"):
                                packet = ConstellationTeamMemberAcceptedPacket(data: data)
                            case ("team", "memberInvited"):
                                packet = ConstellationTeamMemberInvitedPacket(data: data)
                            case ("team", "memberRemoved"):
                                packet = ConstellationTeamMemberRemovedPacket(data: data)
                            case ("team", "ownerChanged"):
                                packet = ConstellationTeamOwnerChangedPacket(data: data)
                            case ("user", "achievement"):
                                packet = ConstellationUserAchievementPacket(data: data)
                            case ("user", "followed"):
                                packet = ConstellationUserFollowedPacket(data: data)
                            case ("user", "notify"):
                                packet = ConstellationUserNotifyPacket(data: data)
                            case ("user", "subscribed"):
                                packet = ConstellationUserSubscribedPacket(data: data)
                            case ("user", "resubscrbed"):
                                packet = ConstellationUserResubscribedPacket(data: data)
                            case ("user", "teamAccepted"):
                                packet = ConstellationUserTeamAcceptedPacket(data: data)
                            case ("user", "teamInvited"):
                                packet = ConstellationUserTeamInvitedPacket(data: data)
                            case ("user", "teamRemoved"):
                                packet = ConstellationUserTeamRemovedPacket(data: data)
                            case ("user", "update"):
                                packet = ConstellationUserUpdatePacket(data: data)
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
