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
    public let storageNode: String?
    public let baseUrl: String?
    public let mainUrl: String?
    public let format: String
    public let createdAt: Date?
    public let updatedAt: Date?
    public let recordingId: Int
    
    public var url: URL? {
        func filePath() -> String? {
            return [
                "dash": "manifest.mpd",
                "hls": "manifest.m3u8",
                "thumbnail": "source.json",
                "raw": "source.mp4",
                "chat": "source.json"
            ][format]
        }
        
        if let baseUrl = baseUrl, let filePath = filePath() {
            return URL(string: "\(baseUrl)\(filePath)")
        } else if let storageNode = storageNode, let mainUrl = mainUrl {
            return URL(string: "https://\(storageNode)/\(id)/\(mainUrl)")
        }
        
        return nil
    }
    
    init(json: JSON) {
        id = json["id"].int ?? 0
        storageNode = json["storageNode"].string
        baseUrl = json["baseUrl"].string
        mainUrl = json["mainUrl"].string
        format = json["format"].string ?? "unknown"
        createdAt = Date.fromBeam(json["createdAt"].string)
        updatedAt = Date.fromBeam(json["updatedAt"].string)
        recordingId = json["recordingId"].int ?? 0
    }
}
