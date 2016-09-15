//
//  ConstellationEvent.swift
//  Pods
//
//  Created by Jack Cook on 8/12/16.
//
//

import Foundation

/// A live event that can be subscribed to through Constellation.
public enum ConstellationEvent: CustomStringConvertible {
    case channelFollowed(channelId: Int)
    case channelHosted(channelId: Int)
    case channelSubscribed(channelId: Int)
    case channelResubscribed(channelId: Int)
    case channelUpdate(channelId: Int)
    case interactiveConnect(channelId: Int)
    case interactiveDisconnect(channelId: Int)
    case teamDeleted(teamId: Int)
    case teamMemberAccepted(teamId: Int)
    case teamMemberInvited(teamId: Int)
    case teamMemberRemoved(teamId: Int)
    case teamOwnerChanged(teamId: Int)
    case userAchievement(userId: Int)
    case userFollowed(userId: Int)
    case userNotify(userId: Int)
    case userSubscribed(userId: Int)
    case userResubscribed(userId: Int)
    case userTeamAccepted(userId: Int)
    case userTeamInvited(userId: Int)
    case userTeamRemoved(userId: Int)
    case userUpdate(userId: Int)
    
    public var description: String {
        switch self {
        case .channelFollowed(let id): return "channel:\(id):followed"
        case .channelHosted(let id): return "channel:\(id):hosted"
        case .channelSubscribed(let id): return "channel:\(id):subscribed"
        case .channelResubscribed(let id): return "channel:\(id):resubscribed"
        case .channelUpdate(let id): return "channel:\(id):update"
        case .interactiveConnect(let id): return "interactive:\(id):connect"
        case .interactiveDisconnect(let id): return "interactive:\(id):disconnected"
        case .teamDeleted(let id): return "team:\(id):deleted"
        case .teamMemberAccepted(let id): return "team:\(id):memberAccepted"
        case .teamMemberInvited(let id): return "team:\(id):memberInvited"
        case .teamMemberRemoved(let id): return "team:\(id):memberRemoved"
        case .teamOwnerChanged(let id): return "team:\(id):ownerChanged"
        case .userAchievement(let id): return "user:\(id):achievement"
        case .userFollowed(let id): return "user:\(id):followed"
        case .userNotify(let id): return "user:\(id):notify"
        case .userSubscribed(let id): return "user:\(id):subscribed"
        case .userResubscribed(let id): return "user:\(id):resubscribed"
        case .userTeamAccepted(let id): return "user:\(id):teamAccepted"
        case .userTeamInvited(let id): return "user:\(id):teamInvited"
        case .userTeamRemoved(let id): return "user:\(id):teamRemoved"
        case .userUpdate(let id): return "user:\(id):update"
        }
    }
}
