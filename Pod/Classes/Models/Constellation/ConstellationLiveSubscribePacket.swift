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
    fileprivate let events: [ConstellationEvent]
    
    /**
     Used to initialize a live subscribe packet.
     
     :param: events The events to subscribe to.
     */
    public init(events: [ConstellationEvent]) {
        self.events = events
    }
    
    public var method: String {
        return "livesubscribe"
    }
    
    public var params: [String : AnyObject] {
        var eventStrings = [String]()
        
        for event in events {
            eventStrings.append(event.description)
        }
        
        return ["events": eventStrings as AnyObject]
    }
}
