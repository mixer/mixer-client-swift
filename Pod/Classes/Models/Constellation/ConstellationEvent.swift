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
    case ChannelFollowed(channelId: Int)
    case ChannelHosted(channelId: Int)
    case ChannelSubscribed(channelId: Int)
    case ChannelResubscribed(channelId: Int)
    case ChannelUpdate(channelId: Int)
    case InteractiveConnect(channelId: Int)
    case InteractiveDisconnect(channelId: Int)
    case TeamDeleted(teamId: Int)
    case TeamMemberAccepted(teamId: Int)
    case TeamMemberInvited(teamId: Int)
    case TeamMemberRemoved(teamId: Int)
    case TeamOwnerChanged(teamId: Int)
    case UserAchievement(userId: Int)
    case UserFollowed(userId: Int)
    case UserNotify(userId: Int)
    case UserSubscribed(userId: Int)
    case UserResubscribed(userId: Int)
    case UserTeamAccepted(userId: Int)
    case UserTeamInvited(userId: Int)
    case UserTeamRemoved(userId: Int)
    case UserUpdate(userId: Int)
    
    public var description: String {
        switch self {
        case .ChannelFollowed(let id): return "channel:\(id):followed"
        case .ChannelHosted(let id): return "channel:\(id):hosted"
        case .ChannelSubscribed(let id): return "channel:\(id):subscribed"
        case .ChannelResubscribed(let id): return "channel:\(id):resubscribed"
        case .ChannelUpdate(let id): return "channel:\(id):update"
        case .InteractiveConnect(let id): return "interactive:\(id):connect"
        case .InteractiveDisconnect(let id): return "interactive:\(id):disconnected"
        case .TeamDeleted(let id): return "team:\(id):deleted"
        case .TeamMemberAccepted(let id): return "team:\(id):memberAccepted"
        case .TeamMemberInvited(let id): return "team:\(id):memberInvited"
        case .TeamMemberRemoved(let id): return "team:\(id):memberRemoved"
        case .TeamOwnerChanged(let id): return "team:\(id):ownerChanged"
        case .UserAchievement(let id): return "user:\(id):achievement"
        case .UserFollowed(let id): return "user:\(id):followed"
        case .UserNotify(let id): return "user:\(id):notify"
        case .UserSubscribed(let id): return "user:\(id):subscribed"
        case .UserResubscribed(let id): return "user:\(id):resubscribed"
        case .UserTeamAccepted(let id): return "user:\(id):teamAccepted"
        case .UserTeamInvited(let id): return "user:\(id):teamInvited"
        case .UserTeamRemoved(let id): return "user:\(id):teamRemoved"
        case .UserUpdate(let id): return "user:\(id):update"
        }
    }
}
