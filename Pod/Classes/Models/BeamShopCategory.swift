//
//  BeamShopCategory.swift
//  Beam
//
//  Created by Jack Cook on 1/9/16.
//  Copyright © 2016 MCProHosting. All rights reserved.
//

import SwiftyJSON

public struct BeamShopCategory {
    
    public let id: Int?
    public let title: String?
    public let desc: String?
    public let color: String?
    
    public init(json: JSON) {
        id = json["id"].int
        title = json["title"].string
        desc = json["description"].string
        color = json["color"].string
    }
}
