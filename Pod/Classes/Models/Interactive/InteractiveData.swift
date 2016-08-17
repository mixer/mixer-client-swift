//
//  InteractiveData.swift
//  Pods
//
//  Created by Jack Cook on 2/27/16.
//
//

import SwiftyJSON

/// Holds data retrieved by InteractiveRoutes.getInteractiveDataByChannel.
public struct InteractiveData {
    
    /// The URL address of the Interactive server that should be connected to.
    public let address: String?
    
    /// The key used for authentication with the Interactive servers.
    public let key: String?
    
    /// The id of the user being authenticated.
    public let userId: Int?
    
    /// The amount of influence that the user has in comparison with other users.
    public let influence: Int?
    
    /// The version of the controls being used by the channel.
    public let version: InteractiveVersion?
    
    /// Used to initialize a Interactive data object given JSON data.
    init(json: JSON) {
        address = json["address"].string
        key = json["key"].string
        userId = json["user"].int
        influence = json["influence"].int
        version = json["version"].dictionary == nil ? nil : InteractiveVersion(json: json["version"])
    }
}
