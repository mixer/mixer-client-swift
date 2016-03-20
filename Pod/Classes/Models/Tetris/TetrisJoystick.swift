//
//  TetrisJoystick.swift
//  Pods
//
//  Created by Jack Cook on 3/9/16.
//
//

import SwiftyJSON

/// A tetris joystick control.
public class TetrisJoystick: TetrisControl {
    
    /// Help text that can be displayed on hover.
    public let help: String?
    
    /// Used to initialize a tetris joystick given JSON data.
    init(json: JSON) {
        help = json["help"].string
        
        let id = json["id"].int ?? 0
        let blueprint = TetrisBlueprint(json: json["blueprint"])
        
        super.init(id: id, blueprint: blueprint)
    }
}
