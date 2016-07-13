//
//  BeamEmoticon.swift
//  Pods
//
//  Created by Jack Cook on 7/13/16.
//
//

import SwiftyJSON

/// An emoticon object.
public struct BeamEmoticon {
    
    /// The emoticon's name (what needs to be typed into chat).
    public let name: String
    
    /// The emoticon's position in its spritesheet.
    public let position: CGPoint
    
    /// Used to initialize an emoticon given JSON data.
    init(name: String, json: JSON) {
        self.name = name
        
        let x = json["x"].int ?? 0
        let y = json["y"].int ?? 0
        
        position = CGPointMake(CGFloat(x), CGFloat(y))
    }
    
    /**
     Crops an emoticon image from its spritesheet.
     
     :param: spritesheet The entire spritesheet image.
     :returns: The cropped emoticon image.
     */
    public func imageFromSpritesheet(spritesheet: UIImage) -> UIImage? {
        let croppedRect = CGRectMake(position.x, position.y, 22, 22)
        if let image = CGImageCreateWithImageInRect(spritesheet.CGImage, croppedRect) {
            return UIImage(CGImage: image)
        }
        
        return nil
    }
}
