//
//  TetrisGame.swift
//  Pods
//
//  Created by Jack Cook on 2/27/16.
//
//

import SwiftyJSON

/// A tetris game object.
public struct TetrisGame {
    
    /// The identifier of the game.
    public let id: Int
    
    /// The id of the user who created the game's controls.
    public let ownerId: Int
    
    /// The name of the game.
    public let name: String?
    
    /// A short description of the game.
    public let description: String?
    
    /// True if the game has versions that have been published.
    public let hasPublishedVersions: Bool
    
    /// Text explaining how to install the game (for broadcasters).
    public let installation: String?
    
    /// Used to initialize a tetris game object given JSON data.
    init(json: JSON) {
        id = json["id"].int ?? 0
        ownerId = json["ownerId"].int ?? 0
        name = json["name"].string
        description = json["description"].string
        hasPublishedVersions = json["hasPublishedVersions"].bool ?? false
        installation = json["installation"].string
    }
}
