//
//  MixerEmoticonPack.swift
//  Pods
//
//  Created by Jack Cook on 7/15/16.
//
//

import SwiftyJSON

/// An emoticon pack object.
public struct MixerEmoticonPack {
    
    /// The string indicating where the pack is stored on backend.
    public let slug: String
    
    /// The emoticon pack's name.
    public let name: String
    
    /// Whether this is the default emote pack.
    public let defaultPack: Bool
    
    /// The authors of this emote pack.
    public let authors: [String]
    
    /// The emoticons provided in this pack.
    public let emoticons: [MixerEmoticon]
    
    /// Used to initialize an emoticon given JSON data.
    init(slug: String, json: JSON) {
        self.slug = slug
        
        name = json["name"].string ?? "Emoticon Pack"
        defaultPack = json["default"].bool ?? false
        
        if let retrievedAuthors = json["authors"].arrayObject as? [String] {
            authors = retrievedAuthors
        } else {
            authors = [String]()
        }
        
        var emoticons = [MixerEmoticon]()
        
        if let retrievedEmoticons = json["emoticons"].dictionary {
            for (name, retrievedEmoticon) in retrievedEmoticons {
                let emoticon = MixerEmoticon(name: name, json: retrievedEmoticon)
                emoticons.append(emoticon)
            }
        }
        
        self.emoticons = emoticons
    }
}
