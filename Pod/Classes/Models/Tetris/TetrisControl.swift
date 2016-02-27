//
//  TetrisControl.swift
//  Pods
//
//  Created by Jack Cook on 2/27/16.
//
//

import SwiftyJSON

public struct TetrisControl {
    
    public let id: Int
    public let key: Int
    public let type: TetrisControlType
    public let cost: Int?
    public let cooldown: Int
    public let text: String?
    public let help: String?
    public let blueprint: TetrisBlueprint?
    
    public init(json: JSON) {
        id = json["id"].int ?? 0
        key = json["key"].int ?? 0
        type = TetrisControlType(value: json["type"].string)
        cost = json["cost"].dictionary?["press"]?.dictionary?["cost"]?.int
        cooldown = json["cooldown"].dictionary?["press"]?.int ?? 0
        text = json["text"].string
        help = json["help"].string
        blueprint = TetrisBlueprint(json: json["blueprint"])
    }
}
