//
//  InteractiveVersion.swift
//  Pods
//
//  Created by Jack Cook on 2/27/16.
//
//

import SwiftyJSON

/// The version of Interactive controls being used by a channel.
public struct InteractiveVersion {
    
    /// The version's identifier.
    public let id: Int
    
    /// The identifier of the version's game.
    public let gameId: Int
    
    /// The semantic version of the version.
    public let version: String?
    
    /// The incremental version number of the version.
    public let versionOrder: Int
    
    /// The version's changelog.
    public let changelog: String?
    
    /// The state that the version is in (e.g. draft).
    public let state: String?
    
    /// The controls that should be generated from the version.
    public var controls: [InteractiveControl]
    
    /// The game that the controls are used for.
    public let game: InteractiveGame?
    
    /// Used to initialize an interactive version given JSON data.
    init(json: JSON) {
        id = json["id"].int ?? 0
        gameId = json["gameId"].int ?? 0
        version = json["version"].string
        versionOrder = json["versionOrder"].int ?? 0
        changelog = json["changelog"].string
        state = json["state"].string
        
        controls = [InteractiveControl]()
        
        if let controls = json["controls"].dictionary {
            if let tactiles = controls["tactiles"]?.array {
                for tactile in tactiles {
                    let control = InteractiveTactile(json: tactile)
                    self.controls.append(control)
                }
            }
            
            if let joysticks = controls["joysticks"]?.array {
                for joystick in joysticks {
                    let control = InteractiveJoystick(json: joystick)
                    self.controls.append(control)
                }
            }
        }
        
        game = InteractiveGame(json: json["game"])
    }
}
