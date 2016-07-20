//
//  BeamAchievement.swift
//  Beam API
//
//  Created by Jack Cook on 4/25/15.
//  Copyright (c) 2016 Beam Interactive, Inc. All rights reserved.
//

import SwiftyJSON

/// An achievement object.
public struct BeamAchievement {
    
    /// The achievement's slug/identifier.
    public let slug: String?
    
    /// The name of the achievement.
    public let name: String?
    
    /// A short description of the achievement.
    public let desc: String?
    
    /// The achievement's number of points.
    public let points: Int?
    
    /// Used to initialize an achievement given JSON data.
    init(json: JSON) {
        slug = json["slug"].string
        name = json["name"].string
        desc = json["description"].string
        points = json["points"].int
    }
}
