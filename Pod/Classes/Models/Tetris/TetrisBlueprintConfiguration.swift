//
//  TetrisBlueprintConfiguration.swift
//  Pods
//
//  Created by Jack Cook on 2/27/16.
//
//

import SwiftyJSON

public struct TetrisBlueprintConfiguration {
    
    public let coordinates: CGPoint
    public let size: CGSize
    public let state: String
    public let grid: TetrisGrid
    
    public init(json: JSON) {
        if let x = json["x"].int,
            y = json["y"].int,
            w = json["width"].int,
            h = json["height"].int {
                coordinates = CGPointMake(CGFloat(x), CGFloat(y))
                size = CGSizeMake(CGFloat(w), CGFloat(h))
        } else {
            coordinates = CGPointZero
            size = CGSizeZero
        }
        
        state = json["state"].string ?? ""
        grid = TetrisGrid(value: json["grid"].string)
    }
}
