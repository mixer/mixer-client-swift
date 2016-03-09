//
//  TetrisControl.swift
//  Pods
//
//  Created by Jack Cook on 2/27/16.
//
//

import SwiftyJSON

public class TetrisControl {
    
    public let blueprint: TetrisBlueprint?
    public let id: Int
    
    public init(id: Int, blueprint: TetrisBlueprint?) {
        self.id = id
        self.blueprint = blueprint
    }
}
