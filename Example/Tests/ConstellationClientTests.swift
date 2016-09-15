//
//  ConstellationClientTests.swift
//  BeamAPI
//
//  Created by Jack Cook on 8/10/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import BeamAPI
import XCTest

class ConstellationClientTests: XCTestCase, ConstellationClientDelegate {
    
    var connectExpectation: XCTestExpectation!
    var packetExpectation: XCTestExpectation!
    
    func testConstellationConnection() {
        connectExpectation = expectation(description: "test connecting to constellation")
        packetExpectation = expectation(description: "test receiving a hello packet")
        
        ConstellationClient.sharedClient.connect(self)
        waitForExpectations(timeout: 100, handler: nil)
    }
    
    func constellationDidConnect() {
        connectExpectation.fulfill()
    }
    
    func constellationDidDisconnect(_ error: NSError?) {
        XCTFail()
    }
    
    func constellationReceivedPacket(_ packet: ConstellationPacket) {
        if let packet = packet as? ConstellationHelloPacket {
            XCTAssertFalse(packet.authenticated)
            
            let event = ConstellationEvent.ChannelUpdate(channelId: 3181)
            let subscribe = ConstellationLiveSubscribePacket(events: [event])
            ConstellationClient.sharedClient.sendPacket(subscribe)
        } else if let packet = packet as? ConstellationReplyPacket {
            XCTAssertNil(packet.result)
            XCTAssertNil(packet.error)
            XCTAssert(packet.id == 0)
            
            packetExpectation.fulfill()
        }
    }
}
