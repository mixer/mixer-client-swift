//
//  ProgressPacket.swift
//  Pods
//
//  Created by Jack Cook on 3/5/16.
//
//

public class ProgressPacket: TetrisPacket {
    
    public let controls: [ProgressPacketControl]
    
    public init(controls: [ProgressPacketControl]) {
        self.controls = controls
    }
}

public class ProgressPacketControl {
    
    public let id: Int
    
    public init(id: Int) {
        self.id = id
    }
}

public class ProgressPacketTactile: ProgressPacketControl {
    
    public let fired: Bool
    public let cooldown: Int
    public let progress: Int
    
    public init(id: Int, fired: Bool, cooldown: Int, progress: Int) {
        self.fired = fired
        self.cooldown = cooldown
        self.progress = progress
        
        super.init(id: id)
    }
}

public class ProgressPacketJoystick: ProgressPacketControl {
    
    public let angle: Float
    public let intensity: Float
    
    public init(id: Int, angle: Float, intensity: Float) {
        self.angle = angle
        self.intensity = intensity
        
        super.init(id: id)
    }
}
