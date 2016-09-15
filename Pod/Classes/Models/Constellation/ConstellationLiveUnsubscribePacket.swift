//
//  ConstellationLiveUnsubscribePacket.swift
//  Pods
//
//  Created by Jack Cook on 8/10/16.
//
//

/// A packet sent to unsubscribe from a constellation event.
public class ConstellationLiveUnsubscribePacket: ConstellationPacket, ConstellationSendable {
    
    /// The events to unsubscribe from.
    fileprivate let events: [ConstellationEvent]
    
    /**
     Used to initialize a live unsubscribe packet.
     
     :param: events The events to unsubscribe from.
     */
    public init(events: [ConstellationEvent]) {
        self.events = events
    }
    
    public var method: String {
        return "liveunsubscribe"
    }
    
    public var params: [String : AnyObject] {
        var eventStrings = [String]()
        
        for event in events {
            eventStrings.append(event.description)
        }
        
        return ["events": eventStrings as AnyObject]
    }
}
