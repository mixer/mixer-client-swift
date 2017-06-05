//
//  MixerRecording.swift
//  Pods
//
//  Created by Jack Cook on 6/12/16.
//
//

import SwiftyJSON

public struct MixerRecording {
    
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
    public let channel: MixerChannel?
    public let vods: [MixerVOD]
    
    init(json: JSON) {
        id = json["id"].int ?? 0
        name = json["name"].string ?? "Untitled VoD"
        typeId = json["typeId"].int
        state = json["state"].string
        viewsTotal = json["viewsTotal"].int ?? 0
        duration = json["duration"].float ?? 0
        expiresAt = Date.fromMixer(json["expiresAt"].string)
        createdAt = Date.fromMixer(json["createdAt"].string)
        updatedAt = Date.fromMixer(json["updatedAt"].string)
        channelId = json["channelId"].int ?? 0
        channel = MixerChannel(json: json["channel"])
        
        var retrievedVODs = [MixerVOD]()
        
        if let vods = json["vods"].array {
            for vod in vods {
                let vodObject = MixerVOD(json: vod)
                retrievedVODs.append(vodObject)
            }
        }
        
        vods = retrievedVODs
    }
}
