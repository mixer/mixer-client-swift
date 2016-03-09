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
    
    public func data() -> [String: AnyObject] {
        var data = [String: AnyObject]()
        
        var tactiles = [String]()
        var joysticks = [String]()
        
        for control in controls {
            if control is ReportPacketTactile {
                tactiles.append(control.description)
            } else if control is ReportPacketJoystick {
                joysticks.append(control.description)
            }
        }
        
        data["joystick"] = joysticks
        data["tactile"] = tactiles
        
        return data
    }
}

public class ReportPacketControl: CustomStringConvertible {
    
    public let id: Int
    
    public init(id: Int) {
        self.id = id
    }
    
    public var description: String {
        return ""
    }
}

public class ReportPacketTactile: ReportPacketControl {
    
    public let down: Bool
    
    public init(id: Int, down: Bool) {
        self.down = down
        
        super.init(id: id)
    }
    
    public override var description: String {
        return "{\"\(down ? "down" : "up")\": 1, \"id\": \(id)}"
    }
}

public class ReportPacketJoystick: ReportPacketControl {
    
    public let x: Float
    public let y: Float
    
    public init(id: Int, x: Float, y: Float) {
        self.x = x
        self.y = y
        
        super.init(id: id)
    }
    
    public override var description: String {
        return "{\"x\": \(x), \"y\": \(y), \"id\": \(id)}"
    }
}
