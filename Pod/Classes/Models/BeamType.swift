//
//  BeamType.swift
//  Beam API
//
//  Created by Jack Cook on 4/26/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import SwiftyJSON

public struct BeamType {
    
    public let id: Int
    public let name: String
    public let parent: String?
    public let desc: String?
    public let source: String?
    public let viewersCurrent: Int
    public let online: Int
    
    public init() {
        id = 0
        name = "All"
        parent = "All"
        desc = ""
        source = "app"
        viewersCurrent = 999999999
        online = 999999999
    }
    
    public init(json: JSON) {
        id = json["id"].int ?? 0
        name = json["name"].string ?? ""
        parent = json["parent"].string
        desc = json["description"].string
        source = json["source"].string
        viewersCurrent = json["viewersCurrent"].int ?? 0
        online = json["online"].int ?? 0
    }
}
