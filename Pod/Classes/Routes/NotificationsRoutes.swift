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
     Updates a user's notification settings.
     
     :param: preferences The notification preferences that will replace the current preferences.
     :param: completion An optional completion block with response data.
     */
    public func updateNotificationPreferences(preferences: BeamNotificationPreferences, completion: ((_ preferences: BeamNotificationPreferences?, _ error: BeamRequestError?) -> Void)?) {
        guard let _ = BeamSession.sharedSession else {
            completion?(nil, .notAuthenticated)
            return
        }
        
        BeamRequest.request("/notifications/preferences", requestType: "PATCH", body: JSON(preferences) as AnyObject) { (json, error) in
            guard let json = json else {
                completion?(nil, error)
                return
            }
            
            let preferences = BeamNotificationPreferences(json: json)
            completion?(preferences, error)
        }
    }
    
    // MARK: Retrieving Notifications
    
    /**
     Retrieves the authenticated user's notification preferences.
     
     :param: completion An optional completion block with response data.
     */
    public func getNotificationPreferences(completion: ((_ preferences: BeamNotificationPreferences?, _ error: BeamRequestError?) -> Void)?) {
        guard let _ = BeamSession.sharedSession else {
            completion?(nil, .notAuthenticated)
            return
        }
        
        BeamRequest.request("/notifications/preferences") { (json, error) in
            guard let json = json else {
                completion?(nil, error)
                return
            }
            
            let preferences = BeamNotificationPreferences(json: json)
            completion?(preferences, error)
        }
    }
}
