//
//  ConstellationLiveSubscribePacket.swift
//  Pods
//
//  Created by Jack Cook on 8/10/16.
//
//

/// A packet sent to subscribe to a constellation event.
public class ConstellationLiveSubscribePacket: ConstellationPacket, ConstellationSendable {
    
    /// The events to subscribe to.
    private let events: [String]
    
    /**
     Used to initialize a live subscribe packet.
     
     :param: events The events to subscribe to.
     */
    public init(events: [String]) {
        self.events = events
    }
    
    public var method: String {
        return "livesubscribe"
    }
    
    public var params: [String : AnyObject] {
        return ["events": events]
    }
}
