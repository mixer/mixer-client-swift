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
    
    // MARK: Retrieving Notifications
    
    /**
     Retrieves all un-expired notifications for a given user.
     
     :param: userId The identifier of the user whose notifications are being requested.
     :param: completion An optional completion block with retrieved notification data.
     */
    public func getNotifications(userId: Int, completion: ((notifications: [BeamNotification]?, error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/notifications", params: ["userId": "\(userId)"]) { (json, error) in
            guard let notifications = json?.array else {
                completion?(notifications: nil, error: error)
                return
            }
            
            var retrievedNotifications = [BeamNotification]()
            
            for notification in notifications {
                let retrievedNotification = BeamNotification(json: notification)
                retrievedNotifications.append(retrievedNotification)
            }
            
            completion?(notifications: retrievedNotifications, error: error)
        }
    }
    
    /**
     Retrieves all notification transports for a given user.
     
     :param: userId The identifier of the user whose notification transports are being requested.
     :param: completion An optional completion block with retrieved notification transport data.
     */
    public func getNotificationTransports(userId: Int, completion: ((transports: [BeamNotificationTransport]?, error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/notifications/transports", params: ["userId": "\(userId)"]) { (json, error) in
            guard let transports = json?.array else {
                completion?(transports: nil, error: error)
                return
            }
            
            var retrievedTransports = [BeamNotificationTransport]()
            
            for transport in transports {
                let retrievedTransport = BeamNotificationTransport(json: transport)
                retrievedTransports.append(retrievedTransport)
            }
            
            completion?(transports: retrievedTransports, error: error)
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
    public func updateNotificationTransport(userId: Int, transport: String, data: [String: AnyObject]?, settings: [[String: AnyObject]]?, turnAllOn: Bool = false, completion: ((transport: BeamNotificationTransport?, error: BeamRequestError?) -> Void)?) {
        let settingDict = settings == nil && turnAllOn ? ["*"] : []
        
        let body: [String: AnyObject] = [
            "userId": "\(userId)",
            "transport": transport,
            "data": data ?? [:],
            "settings": settings ?? [
                [
                    "type": "wentlive",
                    "setting": settingDict
                ]
            ]
        ]
        
        BeamRequest.request("/notifications/transports", requestType: "POST", body: body) { (json, error) in
            guard let json = json where error == nil else {
                completion?(transport: nil, error: error)
                return
            }
            
            let transport = BeamNotificationTransport(json: json)
            completion?(transport: transport, error: error)
        }
    }
}
