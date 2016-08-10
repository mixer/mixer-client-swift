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
            packetExpectation.fulfill()
        }
    }
}
