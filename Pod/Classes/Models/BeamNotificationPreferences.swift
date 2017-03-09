//
//  BeamNotificationPreferences.swift
//  Pods
//
//  Created by Jack Cook on 3/8/17.
//
//

import SwiftyJSON

/// A user's notification preferences.
public struct BeamNotificationPreferences {
    
    /// Whether or not the user has allowed marketing emails.
    public let allowsEmailMarketing: Bool
    
    /// The user's current health statistics.
    public let health: BeamUserHealth
    
    /// The user's id.
    public let id: Int
    
    /// A list of the user's current notifications.
    public let liveNotifications: [BeamNotification]
    
    /// The user's transports that are on by default.
    public let liveOnByDefault: [String]
    
    /// Where the user should be notified for channels they follow.
    public let notifyFollower: [String]
    
    /// Where the user should be notified for channels they're subscribed to.
    public let notifySubscriber: [String]
    
    /// The user's notification transports.
    public var transports: [[String: Any]]?
    
    /// Used to initialize a user's notification preferences given JSON data.
    init(json: JSON) {
        allowsEmailMarketing = json["allowsEmailMarketing"].bool ?? false
        health = BeamUserHealth(json: json["health"])
        id = Int(json["id"].string ?? "0") ?? 0
        
        var retrievedLiveNotifications = [BeamNotification]()
        
        if let liveNotifications = json["liveNotifications"].array {
            for notification in liveNotifications {
                let notification = BeamNotification(json: notification)
                retrievedLiveNotifications.append(notification)
            }
        }
        
        liveNotifications = retrievedLiveNotifications
        
        var retrievedLiveOnByDefault = [String]()
        
        if let liveOnByDefault = json["liveOnByDefault"].array {
            for transport in liveOnByDefault {
                if let transport = transport.string {
                    retrievedLiveOnByDefault.append(transport)
                }
            }
        }
        
        liveOnByDefault = retrievedLiveOnByDefault
        
        var retrievedNotifyFollower = [String]()
        
        if let notifyFollower = json["notifyFollower"].array {
            for transport in notifyFollower {
                if let transport = transport.string {
                    retrievedNotifyFollower.append(transport)
                }
            }
        }
        
        notifyFollower = retrievedNotifyFollower
        
        var retrievedNotifySubscriber = [String]()
        
        if let notifySubscriber = json["notifySubscriber"].array {
            for transport in notifySubscriber {
                if let transport = transport.string {
                    retrievedNotifySubscriber.append(transport)
                }
            }
        }
        
        notifySubscriber = retrievedNotifySubscriber
        
        var retrievedTransports = [[String: Any]]()
        
        if let transports = json["transports"].array {
            for transport in transports {
                if let transport = transport.dictionaryObject {
                    retrievedTransports.append(transport)
                }
            }
        }
        
        transports = retrievedTransports
    }
    
    var dictionary: [String: Any] {
        let health = [
            "eat": self.health.eat,
            "stretch": self.health.stretch
        ]
        
        var notifications = [[String: Any]]()
        
        for notification in liveNotifications {
            notifications.append([
                "payload": notification.payload ?? [String: Any](),
                "sentAt": notification.sentAt?.timeIntervalSince1970 ?? 0,
                "type": notification.type,
                "userId": notification.userId,
                "id": notification.id ?? ""
            ])
        }
        
        return [
            "allowsEmailMarketing": allowsEmailMarketing,
            "health": health,
            "id": id,
            "liveNotifications": notifications,
            "liveOnByDefault": liveOnByDefault,
            "notifyFollower": notifyFollower,
            "notifySubscriber": notifySubscriber,
            "transports": transports
        ]
    }
}
