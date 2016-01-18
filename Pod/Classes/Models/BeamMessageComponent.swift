//
//  BeamMessageComponent.swift
//  Beam API
//
//  Created by Jack Cook on 7/5/15.
//  Copyright (c) 2015 MCProHosting. All rights reserved.
//

import SwiftyJSON

public struct BeamMessageComponent {
    
    public var type: BeamMessageComponentType?
    public var text: String?
    
    public var source: String?
    public var pack: String?
    public var coordinates: CGPoint?
    
    public var userId: Int?
    
    public init(json: JSON, me: Bool) {
        if let type = json["type"].string {
            switch type {
            case "emoticon":
                self.type = .Emoticon
                text = json["text"].string
                
                source = json["source"].string
                pack = json["pack"].string
                
                if let coords = json["coords"].dictionary {
                    let x = CGFloat(coords["x"]!.int!)
                    let y = CGFloat(coords["y"]!.int!)
                    coordinates = CGPointMake(x, y)
                }
            case "inaspacesuit":
                self.type = .SpaceSuit
                userId = json["userId"].int
            case "link":
                self.type = .Link
                text = json["text"].string
            case "text":
                self.type = me ? .Me : .Text
                text = json["data"].string
            default:
                self.type = .Unknown
                text = json["text"].string
                print("Error beam message component: \(json)")
            }
        }
    }
}
