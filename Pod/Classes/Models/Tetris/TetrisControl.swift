//
//  TetrisControl.swift
//  Pods
//
//  Created by Jack Cook on 2/27/16.
//
//

import SwiftyJSON

/// A base tetris control object.
public class TetrisControl {
    
    /// The control's blueprint, containing valid configurations.
    public let blueprint: TetrisBlueprint?
    
    /// The control's identifier.
    public let id: Int
    
    /**
     Used to initialize a tetris control.
     
     :param: id The control's identifier.
     :param: blueprint The control's blueprint, containing valid configurations.
     */
    public init(id: Int, blueprint: TetrisBlueprint?) {
        self.id = id
        self.blueprint = blueprint
    }
}
