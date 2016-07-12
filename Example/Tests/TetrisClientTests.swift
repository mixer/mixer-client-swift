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
    
    var address: String!
    var channel: BeamChannel!
    var expectation: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        
        let semaphore = dispatch_semaphore_create(0)
        
        BeamClient.sharedClient.channels.getChannels(.Interactive) { (channels, error) in
            guard let channels = channels else {
                XCTFail()
                return
            }
            
            XCTAssert(error == nil)
            
            self.channel = channels[0]
            
            BeamClient.sharedClient.tetris.getTetrisDataByChannel(self.channel.id) { (data, error) in
                guard let address = data?.address else {
                    XCTFail()
                    return
                }
                
                self.address = address
                
                dispatch_semaphore_signal(semaphore)
            }
        }
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
    }
    
    func testConnect() {
        expectation = expectationWithDescription("test joining a channel through tetris")
        
        let tetrisClient = TetrisClient(delegate: self)
        tetrisClient.connect(url: address, channelId: channel.id)
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func tetrisDidConnect() {
        expectation.fulfill()
    }
    
    func tetrisChangedState(state: String) {}
    func tetrisDidDisconnect() {}
    func tetrisReceivedPacket(packet: TetrisPacket) {}
}
