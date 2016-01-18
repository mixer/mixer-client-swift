//
//  BeamShopItem.swift
//  Beam
//
//  Created by Jack Cook on 1/9/16.
//  Copyright © 2016 MCProHosting. All rights reserved.
//

import SwiftyJSON

public struct BeamShopItem {
    
    // more will be implemented when some items actually show up in the shop
    public let title: String?
    
    public init(json: JSON) {
        title = json["title"].string
    }
}
