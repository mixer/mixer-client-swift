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
    public let baseUrl: String?
    public let format: String
    public let createdAt: Date?
    public let updatedAt: Date?
    public let recordingId: Int
    
    public var url: URL? {
        let filePath = [
            "dash": "manifest.mpd",
            "hls": "manifest.m3u8",
            "thumbnail": "source.json",
            "raw": "source.mp4",
            "chat": "source.json"
        ][format]
        
        if let baseUrl = baseUrl, let filePath = filePath {
            return URL(string: "\(baseUrl)\(filePath)")
        }
        
        return nil
    }
    
    init(json: JSON) {
        id = json["id"].int ?? 0
        baseUrl = json["baseUrl"].string
        format = json["format"].string ?? "unknown"
        createdAt = Date.fromBeam(json["createdAt"].string)
        updatedAt = Date.fromBeam(json["updatedAt"].string)
        recordingId = json["recordingId"].int ?? 0
    }
}
