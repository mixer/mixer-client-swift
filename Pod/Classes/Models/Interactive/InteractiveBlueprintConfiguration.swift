//
//  InteractiveBlueprintConfiguration.swift
//  Pods
//
//  Created by Jack Cook on 2/27/16.
//
//

import SwiftyJSON

/// The blueprint configuration for a control given a specific state and grid size.
public struct InteractiveBlueprintConfiguration {
    
    /// The control's origin on the grid in this configuration.
    public let coordinates: CGPoint
    
    /// The control's size on the grid in this configuration.
    public let size: CGSize
    
    /// The configuration's control state.
    public let state: String
    
    /// The configuration's grid size.
    public let grid: InteractiveGrid
    
    /// Used to initialize a blueprint configuration given JSON data.
    init(json: JSON) {
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
        grid = InteractiveGrid(value: json["grid"].string)
    }
}
