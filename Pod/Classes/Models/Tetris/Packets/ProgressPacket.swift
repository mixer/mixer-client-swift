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
    
    public let fired: Bool
    public let id: Int
    public let cooldown: Int
    public let progress: Int
    
    public init(fired: Bool, id: Int, cooldown: Int, progress: Int) {
        self.fired = fired
        self.id = id
        self.cooldown = cooldown
        self.progress = progress
    }
}
