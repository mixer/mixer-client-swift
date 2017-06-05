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
    public func updateNotificationPreferences(preferences: MixerNotificationPreferences, completion: ((_ preferences: MixerNotificationPreferences?, _ error: MixerRequestError?) -> Void)?) {
        guard let id = MixerSession.sharedSession?.user.id else {
            completion?(nil, .notAuthenticated)
            return
        }
        
        MixerRequest.request("/users/\(id)/notifications/preferences", requestType: "PATCH", body: preferences.dictionary as AnyObject) { (json, error) in
            guard let json = json else {
                completion?(nil, error)
                return
            }
            
            let preferences = MixerNotificationPreferences(json: json)
            completion?(preferences, error)
        }
    }
    
    // MARK: Retrieving Notifications
    
    /**
     Retrieves the authenticated user's notification preferences.
     
     :param: completion An optional completion block with response data.
     */
    public func getNotificationPreferences(completion: ((_ preferences: MixerNotificationPreferences?, _ error: MixerRequestError?) -> Void)?) {
        guard let id = MixerSession.sharedSession?.user.id else {
            completion?(nil, .notAuthenticated)
            return
        }
        
        MixerRequest.request("/users/\(id)/notifications/preferences") { (json, error) in
            guard let json = json else {
                completion?(nil, error)
                return
            }
            
            let preferences = MixerNotificationPreferences(json: json)
            completion?(preferences, error)
        }
    }
}
