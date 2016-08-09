//
//  BeamNotification.swift
//  Pods
//
//  Created by Jack Cook on 8/9/16.
//
//

import SwiftyJSON

/// A notification object.
public struct BeamNotification {
    
    /// The payload, containing the notification's data.
    public let payload: [String: AnyObject]?
    
    /// The notification's identifier.
    public let id: Int
    
    /// The type of notification.
    public let type: String
    
    /// The date, in UTC, at which this notification was seen.
    public let seenAt: NSDate?
    
    /// The date, in UTC, at which this notification was sent.
    public let sentAt: NSDate?
    
    /// The date, in UTC, at which this notification will expire.
    public let expiresAt: NSDate?
    
    /// The identifier of the user who received this notification.
    public let userId: Int
    
    /// Used to initialize a notification given JSON data.
    init(json: JSON) {
        payload = json["payload"].dictionaryObject
        id = json["id"].int ?? 0
        type = json["type"].string ?? "unknown"
        seenAt = NSDate.fromBeam(json["seenAt"].string)
        sentAt = NSDate.fromBeam(json["sentAt"].string)
        expiresAt = NSDate.fromBeam(json["expiresAt"].string)
        userId = json["userId"].int ?? 0
    }
}
