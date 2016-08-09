//
//  BeamNotificationTransportSettings.swift
//  Pods
//
//  Created by Jack Cook on 8/9/16.
//
//

import SwiftyJSON

/// A notification transport settings object.
public struct BeamNotificationTransportSettings {
    
    /// The list of channel ids that are included or excluded from receiving notifications.
    public let setting: [String]
    
    /// The setting's identifier.
    public let id: Int
    
    /// The type of notification that this setting is acting for.
    public let type: String
    
    /// The identifier of the transport this setting is attached to.
    public let transportId: Int
    
    /// Used to initialize a notification transport setting given JSON data.
    init(json: JSON) {
        var retrievedSettings = [String]()
        
        if let settings = json["setting"].array {
            for setting in settings {
                if let settingString = setting.string {
                    retrievedSettings.append(settingString)
                }
            }
        }
        
        setting = retrievedSettings
        id = json["id"].int ?? 0
        type = json["type"].string ?? "unknown"
        transportId = json["transportId"].int ?? 0
    }
}
