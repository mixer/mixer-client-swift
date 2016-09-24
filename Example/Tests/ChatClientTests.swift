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
    
    let channelId = 252
    var expectation: XCTestExpectation!
    
    func testChatConnect() {
        expectation = self.expectation(description: "test joining a channel's chat")
        
        let chatClient = ChatClient(delegate: self)
        chatClient.joinChannel(channelId)
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func chatDidConnect() {
        expectation.fulfill()
    }
    
    func chatReceivedPacket(_ packet: ChatPacket) {}
}
