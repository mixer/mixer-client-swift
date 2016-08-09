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
}
