//
//  BeamShopItem.swift
//  Beam
//
//  Created by Jack Cook on 1/9/16.
//  Copyright © 2016 MCProHosting. All rights reserved.
//

import SwiftyJSON

/// An item in Beam's shop. More will be implemented when items are added to the shop.
public struct BeamShopItem {
    
    /// The title of the shop item.
    public let title: String?
    
    /// Used to initialize a shop item given JSON data.
    init(json: JSON) {
        title = json["title"].string
    }
}
