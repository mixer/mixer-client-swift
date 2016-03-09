//
//  TetrisVersion.swift
//  Pods
//
//  Created by Jack Cook on 2/27/16.
//
//

import SwiftyJSON

public struct TetrisVersion {
    
    public let id: Int
    public let gameId: Int
    public let version: String?
    public let versionOrder: Int
    public let changelog: String?
    public let state: String?
    
    public var controls: [TetrisControl]
    public let game: TetrisGame?
    
    public init(json: JSON) {
        id = json["id"].int ?? 0
        gameId = json["gameId"].int ?? 0
        version = json["version"].string
        versionOrder = json["versionOrder"].int ?? 0
        changelog = json["changelog"].string
        state = json["state"].string
        
        controls = [TetrisControl]()
        
        if let controls = json["controls"].dictionary {
            if let tactiles = controls["tactiles"]?.array {
                for tactile in tactiles {
                    let control = TetrisTactile(json: tactile)
                    self.controls.append(control)
                }
            }
            
            if let joysticks = controls["joysticks"]?.array {
                for joystick in joysticks {
                    let control = TetrisJoystick(json: joystick)
                    self.controls.append(control)
                }
            }
        }
        
        game = TetrisGame(json: json["game"])
    }
}
