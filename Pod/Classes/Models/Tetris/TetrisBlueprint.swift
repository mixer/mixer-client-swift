//
//  TetrisBlueprint.swift
//  Pods
//
//  Created by Jack Cook on 2/27/16.
//
//

import SwiftyJSON

public struct TetrisBlueprint {
    
    public var configurations: [TetrisBlueprintConfiguration]
    
    public init(json: JSON) {
        self.configurations = [TetrisBlueprintConfiguration]()
        
        if let configurations = json.array {
            for configurationData in configurations {
                let configuration = TetrisBlueprintConfiguration(json: configurationData)
                self.configurations.append(configuration)
            }
        }
    }
}
