//
//  InteractiveTactile.swift
//  Pods
//
//  Created by Jack Cook on 3/9/16.
//
//

import SwiftyJSON

/// An interactive tactile control.
public class InteractiveTactile: InteractiveControl {
    
    /// The unicode number of the key the tactile would bind to on a keyboard.
    public let key: Int
    
    /// The text that should be displayed on the tactile.
    public let text: String?
    
    /// Help text that can be displayed on hover.
    public let help: String?
    
    /// The cost of pressing the tactile.
    public let cost: Int?
    
    /// The number of seconds a button cannot be pressed for after pressing it once.
    public let cooldown: Int?
    
    /// Used to initialize an interactive tactile given JSON data.
    init(json: JSON) {
        key = json["key"].int ?? 0
        text = json["text"].string
        help = json["help"].string
        cost = json["cost"].dictionary?["press"]?.dictionary?["cost"]?.int
        cooldown = json["cooldown"].dictionary?["press"]?.int ?? 0
        
        let id = json["id"].int ?? 0
        let blueprint = InteractiveBlueprint(json: json["blueprint"])
        
        super.init(id: id, blueprint: blueprint)
    }
}
