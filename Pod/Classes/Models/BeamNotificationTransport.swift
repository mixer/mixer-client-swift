//
//  BeamNotificationTransport.swift
//  Pods
//
//  Created by Jack Cook on 8/9/16.
//
//

import SwiftyJSON

/// A notification transport object.
public struct BeamNotificationTransport {
    
    /// Any transport-independent data that may be useful to the app.
    public let data: [String: AnyObject]?
    
    /// The notification transport's identifier.
    public let id: Int
    
    /// The name of the transport.
    public let transport: String
    
    /// The identifier of the user who this transport belongs to.
    public let userId: Int
    
    /// Preferences for this transport, notably including included/excluded channel ids.
    public let settings: [BeamNotificationTransportSettings]
    
    /// Used to initialize a notification transport given JSON data.
    init(json: JSON) {
        data = json["data"].dictionaryObject as? [String: AnyObject]
        id = json["id"].int ?? 0
        transport = json["transport"].string ?? "unknown"
        userId = json["userId"].int ?? 0
        
        var retrievedSettings = [BeamNotificationTransportSettings]()
        
        if let settings = json["settings"].array {
            for setting in settings {
                let retrievedSetting = BeamNotificationTransportSettings(json: setting)
                retrievedSettings.append(retrievedSetting)
            }
        }
        
        settings = retrievedSettings
    }
}
