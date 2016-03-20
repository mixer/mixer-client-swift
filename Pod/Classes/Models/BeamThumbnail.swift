//
//  BeamThumbnail.swift
//  Beam API
//
//  Created by Jack Cook on 4/25/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import SwiftyJSON

/// A channel thumbnail object.
public struct BeamThumbnail {
    
    /// The identifier of the thumbnail.
    public let id: Int?
    
    /// The relid of the thumbnail.
    public let relid: Int?
    
    /// A URL of the thumbnail image.
    public let url: String?
    
    /// The store of the thumbnail on Beam's servers.
    public let store: String?
    
    /// The path of the thumbnail on Beam's servers.
    public let remotePath: String?
    
    /// The first time at which the channel was given a thumbnail.
    public let createdAt: NSDate?
    
    /// The most recent time at which the channel's thumbnail was updated.
    public let updatedAt: NSDate?
    
    /// The size of the thumbnail image.
    public var size: CGSize?
    
    /// Used to initialize a thumbnail given JSON data.
    init(json: JSON) {
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
