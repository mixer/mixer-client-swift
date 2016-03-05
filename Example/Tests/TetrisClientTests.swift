//
//  TetrisClientTests.swift
//  BeamAPI
//
//  Created by Jack Cook on 3/5/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import BeamAPI
import XCTest

class TetrisClientTests: XCTestCase, TetrisClientDelegate {
    
    var channel: BeamChannel!
    var expectation: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        
        let semaphore = dispatch_semaphore_create(0)
        
        BeamClient.sharedClient.channels.getDefaultChannels { (channels, error) -> Void in
            guard var channels = channels else {
                XCTFail()
                return
            }
            
            XCTAssert(error == nil)
            
            channels.sortInPlace({ $0.0.interactive })
            self.channel = channels[0]
            
            dispatch_semaphore_signal(semaphore)
        }
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
    }
    
    func testConnect() {
        expectation = expectationWithDescription("test joining a channel through tetris")
        
        let tetrisClient = TetrisClient(delegate: self)
        tetrisClient.connect(url: "wss://tetris1-dal.beam.pro", channelId: 50772)
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func tetrisDidConnect() {
        expectation.fulfill()
    }
    
    func tetrisReceivedPacket(packet: TetrisPacket) {}
}
