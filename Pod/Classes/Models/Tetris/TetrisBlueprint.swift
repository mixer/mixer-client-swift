//
//  TetrisBlueprint.swift
//  Pods
//
//  Created by Jack Cook on 2/27/16.
//
//

import SwiftyJSON

/// A control's set of configurations for certain states and grid sizes.
public struct TetrisBlueprint {
    
    /// The possible configurations in the control's blueprint.
    public var configurations: [TetrisBlueprintConfiguration]
    
    /// Used to initialize a blueprint given JSON data.
    init(json: JSON) {
        self.configurations = [TetrisBlueprintConfiguration]()
        
        if let configurations = json.array {
            for configurationData in configurations {
                let configuration = TetrisBlueprintConfiguration(json: configurationData)
                self.configurations.append(configuration)
            }
        }
    }
}
