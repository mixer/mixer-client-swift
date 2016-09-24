//
//  BeamMessageComponent.swift
//  Beam API
//
//  Created by Jack Cook on 7/5/15.
//  Copyright (c) 2016 Beam Interactive, Inc. All rights reserved.
//

import SwiftyJSON

/// A chat message component object.
public struct BeamMessageComponent {
    
    /// The type of message component.
    public var type: BeamMessageComponentType?
    
    /// The text that can be appended to the chat message in place of less rich content.
    public var text: String?
    
    /// The source of an emoticon, if applicable.
    public var source: String?
    
    /// The pack that the emoticon is from, if applicable.
    public var pack: String?
    
    /// The coordinates of the emoticon in the pack's spritesheet, if applicable.
    public var coordinates: CGPoint?
    
    /// The id of the user in a spacesuit or user being tagged, if applicable.
    public var userId: Int?
    
    /// The name of the user being tagged, if applicable.
    public var username: String?
    
    /// Used to initialize a chat message component given JSON data.
    init(json: JSON, me: Bool) {
        if let type = json["type"].string {
            switch type {
            case "emoticon":
                self.type = .Emoticon
                text = json["text"].string
                
                source = json["source"].string
                pack = json["pack"].string
                
                if let coords = json["coords"].dictionary, let xc = coords["x"]?.int, let yc = coords["y"]?.int {
                    let x = CGFloat(xc)
                    let y = CGFloat(yc)
                    coordinates = CGPoint(x: x, y: y)
                }
            case "inaspacesuit":
                self.type = .SpaceSuit
                userId = json["userId"].int
            case "link":
                self.type = .Link
                text = json["text"].string
            case "tag":
                self.type = .Tag
                text = json["text"].string
                userId = json["id"].int
                username = json["username"].string
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
