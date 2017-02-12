//
//  NotificationsRoutes.swift
//  Pods
//
//  Created by Jack Cook on 8/9/16.
//
//

import SwiftyJSON

/// Routes that can be used to interact with and retrieve notification data.
public class NotificationsRoutes {
    
    // MARK: Acting on Notifications
    
    /**
     Marks all notifications sent before a given date as having been read.
     
     :param: userId The identifier of the user whose notifications are being marked as read.
     :param: date The date before which notifications should be marked as read.
     :param: completion An optional completion block with response data.
     */
    public func markNotificationsAsRead(_ userId: Int, beforeDate date: Date, completion: ((_ error: BeamRequestError?) -> Void)?) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let body = ["date": formatter.string(from: date)] as AnyObject
        
        BeamRequest.request("/notifications/read", requestType: "POST", params: ["userId": "\(userId)"], body: body, options: .mayNeedCSRF) { (json, error) in
            completion?(error)
        }
    }
    
    /**
     Creates a notification transport, or updates it if one exists with the same transport type.
     
     :param: userId The identifier of the user who will be using this notification transport.
     :param: transport The type of transport being updated (e.g. email, push)
     :param: data Transport-independent data about how it should work.
     :param: settings Settings about when this transport should be used.
     :param: turnAllOn If this is true and settings are not provided, all notifications for this transport will be turned on. This is false by default.
     :param: completion An optional completion block with response data.
     */
    public func updateNotificationTransport(_ userId: Int, transport: String, data: [String: AnyObject]?, settings: [[String: AnyObject]]?, turnAllOn: Bool = false, completion: ((_ transport: BeamNotificationTransport?, _ error: BeamRequestError?) -> Void)?) {
        let settingDict = settings == nil && turnAllOn ? ["*"] : []
        
        let body = [
            "userId": "\(userId)",
            "transport": transport,
            "data": data ?? [:],
            "settings": settings ?? [
                [
                    "type": "wentlive",
                    "setting": settingDict
                ]
            ] as [[String: Any]]
        ] as AnyObject
        
        BeamRequest.request("/notifications/transports", requestType: "POST", body: body, options: .mayNeedCSRF) { (json, error) in
            guard let json = json , error == nil else {
                completion?(nil, error)
                return
            }
            
            let transport = BeamNotificationTransport(json: json)
            completion?(transport, error)
        }
    }
    
    /**
     Deletes a notification transport.
     
     :param: userId The identifier of the user whose transport is being deleted.
     :param: transportId The identifier of the transport being deleted.
     :param: completion An optional completion block with response data.
     */
    public func deleteNotificationTransport(_ userId: Int, transportId: Int, completion: ((_ error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/notifications/transports/\(transportId)", requestType: "DELETE", params: ["userId": "\(userId)"], options: .mayNeedCSRF) { (json, error) in
            completion?(error)
        }
    }
    
    // MARK: Retrieving Notifications
    
    /**
     Retrieves all un-expired notifications for a given user.
     
     :param: userId The identifier of the user whose notifications are being requested.
     :param: completion An optional completion block with retrieved notification data.
     */
    public func getNotifications(_ userId: Int, completion: ((_ notifications: [BeamNotification]?, _ error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/notifications", params: ["userId": "\(userId)"]) { (json, error) in
            guard let notifications = json?.array else {
                completion?(nil, error)
                return
            }
            
            var retrievedNotifications = [BeamNotification]()
            
            for notification in notifications {
                let retrievedNotification = BeamNotification(json: notification)
                retrievedNotifications.append(retrievedNotification)
            }
            
            completion?(retrievedNotifications, error)
        }
    }
    
    /**
     Retrieves all notification transports for a given user.
     
     :param: userId The identifier of the user whose notification transports are being requested.
     :param: completion An optional completion block with retrieved notification transport data.
     */
    public func getNotificationTransports(_ userId: Int, completion: ((_ transports: [BeamNotificationTransport]?, _ error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/notifications/transports", params: ["userId": "\(userId)"]) { (json, error) in
            guard let transports = json?.array else {
                completion?(nil, error)
                return
            }
            
            var retrievedTransports = [BeamNotificationTransport]()
            
            for transport in transports {
                let retrievedTransport = BeamNotificationTransport(json: transport)
                retrievedTransports.append(retrievedTransport)
            }
            
            completion?(retrievedTransports, error)
        }
    }
}
