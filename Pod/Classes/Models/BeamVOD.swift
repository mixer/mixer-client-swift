//
//  BeamVOD.swift
//  Pods
//
//  Created by Jack Cook on 6/12/16.
//
//

import SwiftyJSON

public struct BeamVOD {
    
    public let id: Int
    public let storageNode: String
    public let mainUrl: String
    public let format: String
    public let createdAt: NSDate?
    public let updatedAt: NSDate?
    public let recordingId: Int
    
    public var url: NSURL {
        return NSURL(string: "https://\(storageNode)/\(id)/\(mainUrl)")!
    }
    
    init(json: JSON) {
        id = json["id"].int ?? 0
        storageNode = json["storageNode"].string ?? ""
        mainUrl = json["mainUrl"].string ?? ""
        format = json["format"].string ?? ""
        createdAt = NSDate.fromBeam(json["createdAt"].string)
        updatedAt = NSDate.fromBeam(json["updatedAt"].string)
        recordingId = json["recordingId"].int ?? 0
    }
}
