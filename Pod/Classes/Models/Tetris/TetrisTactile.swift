//
//  TetrisTactile.swift
//  Pods
//
//  Created by Jack Cook on 3/9/16.
//
//

import SwiftyJSON

public class TetrisTactile: TetrisControl {
    
    public let key: Int
    public let text: String?
    public let help: String?
    public let cost: Int?
    public let cooldown: Int?
    
    public init(json: JSON) {
        key = json["key"].int ?? 0
        text = json["text"].string
        help = json["help"].string
        cost = json["cost"].dictionary?["press"]?.dictionary?["cost"]?.int
        cooldown = json["cooldown"].dictionary?["press"]?.int ?? 0
        
        let id = json["id"].int ?? 0
        let blueprint = TetrisBlueprint(json: json["blueprint"])
        
        super.init(id: id, blueprint: blueprint)
    }
}
