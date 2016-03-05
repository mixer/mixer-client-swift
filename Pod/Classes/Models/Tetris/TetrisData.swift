//
//  TetrisData.swift
//  Pods
//
//  Created by Jack Cook on 2/27/16.
//
//

import SwiftyJSON

public struct TetrisData {
    
    public let address: String?
    public let key: String?
    public let userId: Int?
    public let influence: Int?
    public let version: TetrisVersion?
    
    public init(json: JSON) {
        address = json["address"].string
        key = json["key"].string
        userId = json["user"].int
        influence = json["influence"].int
        version = json["version"].dictionary == nil ? nil : TetrisVersion(json: json["version"])
    }
}
