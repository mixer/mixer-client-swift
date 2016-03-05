//
//  ReportPacket.swift
//  Pods
//
//  Created by Jack Cook on 3/5/16.
//
//

public class ReportPacket: TetrisPacket, TetrisSendable {
    
    public let controls: [ReportPacketControl]
    
    public init(controls: [ReportPacketControl]) {
        self.controls = controls
    }
    
    public var identifier: String {
        return "data"
    }
    
    public func data() -> [String: AnyObject?] {
        var data = [String: AnyObject]()
        
        var joysticks = [String]()
        var tactiles = [String]()
        
        for control in controls {
            if control.type == .Button {
                joysticks.append(control.description)
            }
        }
        
        data["joystick"] = joysticks
        data["tactile"] = tactiles
        
        return data
    }
}

public class ReportPacketControl: CustomStringConvertible {
    
    public let down: Bool
    public let id: Int
    public let type: TetrisControlType
    
    public init(down: Bool, id: Int, type: TetrisControlType) {
        self.down = down
        self.id = id
        self.type = type
    }
    
    public var description: String {
        return "{\"down\": \(down ? 1 : 0), \"id\": \(id)}"
    }
}
