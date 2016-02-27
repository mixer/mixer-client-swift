//
//  TetrisGame.swift
//  Pods
//
//  Created by Jack Cook on 2/27/16.
//
//

import SwiftyJSON

public struct TetrisGame {
    
    public let id: Int
    public let ownerId: Int
    public let name: String?
    public let description: String?
    public let hasPublishedVersions: Bool
    public let installation: String?
    
    public init(json: JSON) {
        id = json["id"].int ?? 0
        ownerId = json["ownerId"].int ?? 0
        name = json["name"].string
        description = json["description"].string
        hasPublishedVersions = json["hasPublishedVersions"].bool ?? false
        installation = json["installation"].string
    }
}
