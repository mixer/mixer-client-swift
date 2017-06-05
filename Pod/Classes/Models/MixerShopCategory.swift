//
//  MixerShopCategory.swift
//  Mixer
//
//  Created by Jack Cook on 1/9/16.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//

import SwiftyJSON

/// A category in Mixer's shop.
public struct MixerShopCategory {
    
    /// The category's identifier.
    public let id: Int?
    
    /// The title of the category.
    public let title: String?
    
    /// A short description of the category.
    public let desc: String?
    
    /// The category's color.
    public let color: String?
    
    /// Used to initialize a shop category given JSON data.
    init(json: JSON) {
        id = json["id"].int
        title = json["title"].string
        desc = json["description"].string
        color = json["color"].string
    }
}
