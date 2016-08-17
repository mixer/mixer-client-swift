//
//  InteractiveJoystick.swift
//  Pods
//
//  Created by Jack Cook on 3/9/16.
//
//

import SwiftyJSON

/// An interactive joystick control.
public class InteractiveJoystick: InteractiveControl {
    
    /// Help text that can be displayed on hover.
    public let help: String?
    
    /// Used to initialize an interactive joystick given JSON data.
    init(json: JSON) {
        help = json["help"].string
        
        let id = json["id"].int ?? 0
        let blueprint = InteractiveBlueprint(json: json["blueprint"])
        
        super.init(id: id, blueprint: blueprint)
    }
}
