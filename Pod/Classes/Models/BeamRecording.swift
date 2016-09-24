//
//  BeamRecording.swift
//  Pods
//
//  Created by Jack Cook on 6/12/16.
//
//

import SwiftyJSON

public struct BeamRecording {
    
    public let id: Int
    public let name: String
    public let typeId: Int?
    public let state: String?
    public let viewsTotal: Int
    public let duration: Float
    public let expiresAt: Date?
    public let createdAt: Date?
    public let updatedAt: Date?
    public let channelId: Int
    public let channel: BeamChannel?
    public let vods: [BeamVOD]
    
    init(json: JSON) {
        id = json["id"].int ?? 0
        name = json["name"].string ?? "Untitled VoD"
        typeId = json["typeId"].int
        state = json["state"].string
        viewsTotal = json["viewsTotal"].int ?? 0
        duration = json["duration"].float ?? 0
        expiresAt = Date.fromBeam(json["expiresAt"].string)
        createdAt = Date.fromBeam(json["createdAt"].string)
        updatedAt = Date.fromBeam(json["updatedAt"].string)
        channelId = json["channelId"].int ?? 0
        channel = BeamChannel(json: json["channel"])
        
        var retrievedVODs = [BeamVOD]()
        
        if let vods = json["vods"].array {
            for vod in vods {
                let vodObject = BeamVOD(json: vod)
                retrievedVODs.append(vodObject)
            }
        }
        
        vods = retrievedVODs
    }
}
