//
//  ChatClientTests.swift
//  MixerAPI
//
//  Created by Jack Cook on 1/30/16.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//

import MixerAPI
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
