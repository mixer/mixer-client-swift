//
//  ChatClientTests.swift
//  BeamAPI
//
//  Created by Jack Cook on 1/30/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import BeamAPI
import XCTest

class ChatClientTests: XCTestCase, ChatClientDelegate {
    
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
            
            channels.sortInPlace({ $0.viewersCurrent > $1.viewersCurrent })
            self.channel = channels[0]
            
            dispatch_semaphore_signal(semaphore)
        }
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
    }
    
    func testChatConnect() {
        expectation = expectationWithDescription("test joining a channel's chat")
        
        let chatClient = ChatClient(delegate: self)
        chatClient.joinChannel(channel.id)
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func didConnect() {
        expectation.fulfill()
    }
    
    func receivedPacket(packet: Packet) {}
    func updateWithViewers(viewers: Int) {}
}
