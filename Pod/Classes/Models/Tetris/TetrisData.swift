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
    public let version: TetrisVersion?
    
    public init(json: JSON) {
        address = json["address"].string
        version = json["version"].dictionary == nil ? nil : TetrisVersion(json: json["version"])
    }
}
