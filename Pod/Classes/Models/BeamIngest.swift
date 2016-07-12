//
//  BeamIngest.swift
//  Pods
//
//  Created by Jack Cook on 7/12/16.
//
//

import SwiftyJSON

/// An ingest object.
public struct BeamIngest {
    
    /// The ingest's name.
    public let name: String?
    
    /// The ingest's host url.
    public let host: String?
    
    /// A WSS URL that can be used to test your connection to the ingest.
    public let pingTest: String?
    
    /// A list of protocols supported by this ingest server.
    public let protocols: [String]
    
    /// Used to initialize an ingest given JSON data.
    init(json: JSON) {
        name = json["name"].string
        host = json["host"].string
        pingTest = json["pingTest"].string
        
        var protocols = [String]()
        
        if let protocolsList = json["protocols"].array {
            for beamProtocol in protocolsList {
                if let protocolName = beamProtocol["type"].string {
                    protocols.append(protocolName)
                }
            }
        }
        
        self.protocols = protocols
    }
}
