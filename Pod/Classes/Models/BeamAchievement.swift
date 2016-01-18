//
//  BeamAchievement.swift
//  Beam API
//
//  Created by Jack Cook on 4/25/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import SwiftyJSON

public struct BeamAchievement {
    
    public let slug: String?
    public let name: String?
    public let desc: String?
    public let points: Int?
    
    public init(json: JSON) {
        slug = json["slug"].string
        name = json["name"].string
        desc = json["description"].string
        points = json["points"].int
    }
}
