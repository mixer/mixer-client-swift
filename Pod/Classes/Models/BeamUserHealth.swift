//
//  MixerUserHealth.swift
//  Pods
//
//  Created by Jack Cook on 3/8/17.
//
//

import SwiftyJSON

/// Statistics about the user's health.
public struct MixerUserHealth {
    
    /// Time until the user needs to eat.
    public let eat: Int
    
    /// Time until the user needs to stretch.
    public let stretch: Int
    
    /// Used to initialize a user health type given JSON data.
    init(json: JSON) {
        eat = json["eat"].int ?? 0
        stretch = json["stretch"].int ?? 0
    }
}
