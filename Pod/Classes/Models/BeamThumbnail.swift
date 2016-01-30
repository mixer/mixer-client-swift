//
//  BeamThumbnail.swift
//  Beam API
//
//  Created by Jack Cook on 4/25/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import SwiftyJSON

public struct BeamThumbnail {
    
    public let id: Int?
    public let relid: Int?
    public let url: String?
    public let store: String?
    public let remotePath: String?
    public let createdAt: NSDate?
    public let updatedAt: NSDate?
    
    public var size: CGSize?
    
    public init(json: JSON) {
        if let size = json["meta"]["size"].array,
            w = size[0].int, h = size[1].int {
            let width = CGFloat(w)
            let height = CGFloat(h)
            self.size = CGSizeMake(width, height)
        }
        
        id = json["id"].int
        relid = json["relid"].int
        url = json["url"].string
        store = json["store"].string
        remotePath = json["remotePath"].string
        createdAt = NSDate.fromBeam(json["createdAt"].string)
        updatedAt = NSDate.fromBeam(json["updatedAt"].string)
    }
}
