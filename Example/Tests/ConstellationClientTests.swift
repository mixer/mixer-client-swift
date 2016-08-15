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
        connectExpectation = expectationWithDescription("test connecting to constellation")
        packetExpectation = expectationWithDescription("test receiving a hello packet")
        
        ConstellationClient.sharedClient.connect(self)
        waitForExpectationsWithTimeout(100, handler: nil)
    }
    
    func constellationDidConnect() {
        connectExpectation.fulfill()
    }
    
    func constellationDidDisconnect(error: NSError?) {
        XCTFail()
    }
    
    func constellationReceivedPacket(packet: ConstellationPacket) {
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
