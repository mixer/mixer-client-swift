//
//  InteractiveClientTests.swift
//  BeamAPI
//
//  Created by Jack Cook on 3/5/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import BeamAPI
import XCTest

class InteractiveClientTests: XCTestCase, InteractiveClientDelegate {
    
    var address: String!
    var channel: BeamChannel!
    var client: InteractiveClient!
    var expectation: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        
        let semaphore = dispatch_semaphore_create(0)
        
        BeamClient.sharedClient.channels.getChannels(.Interactive) { (channels, error) in
            guard let channel = channels?[0] else {
                XCTFail()
                return
            }
            
            XCTAssertNil(error)
            
            self.channel = channel
            
            BeamClient.sharedClient.interactive.getInteractiveDataByChannel(self.channel.id) { (data, error) in
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
        expectation = expectationWithDescription("test joining a channel with interactive capabilities")
        
        client = InteractiveClient(delegate: self)
        client.connect(url: address, channelId: channel.id)
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func interactiveDidConnect() {
        client.disconnect()
    }
    
    func interactiveDidDisconnect() {
        expectation.fulfill()
    }
    
    func interactiveChangedState(state: String) {}
    func interactiveReceivedPacket(packet: InteractivePacket) {}
}
