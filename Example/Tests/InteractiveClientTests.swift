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
        
        let semaphore = DispatchSemaphore(value: 0)
        
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
        
        semaphore.wait(timeout: DispatchTime.distantFuture)
    }
    
    func testConnect() {
        expectation = self.expectation(withDescription: "test joining a channel with interactive capabilities")
        
        client = InteractiveClient(delegate: self)
        client.connect(url: address, channelId: channel.id)
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func interactiveDidConnect() {
        client.disconnect()
    }
    
    func interactiveDidDisconnect() {
        expectation.fulfill()
    }
    
    func interactiveChangedState(_ state: String) {}
    func interactiveReceivedPacket(_ packet: InteractivePacket) {}
}
