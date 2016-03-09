//
//  TetrisJoystick.swift
//  Pods
//
//  Created by Jack Cook on 3/9/16.
//
//

import SwiftyJSON

public class TetrisJoystick: TetrisControl {
    
    public let help: String?
    
    public init(json: JSON) {
        help = json["help"].string
        
        let id = json["id"].int ?? 0
        let blueprint = TetrisBlueprint(json: json["blueprint"])
        
        super.init(id: id, blueprint: blueprint)
    }
}
