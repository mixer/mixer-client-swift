//
//  ChatTests.swift
//  BeamAPI
//
//  Created by Jack Cook on 1/30/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import BeamAPI
import XCTest

class ChatTests: XCTestCase {
    
    let channelId = 252
    let messageId = "aaaa"
    let query = "aaaa"
    let userId = 278
    
    func testDeleteAllChatMessages() {
        let expectation = expectationWithDescription("tests deleting all chat messages from a channel")
        
        BeamClient.sharedClient.chat.deleteAllChatMessages(channelId) { (error) in
            XCTAssert(error == .NotAuthenticated)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testDeleteChatMessage() {
        let expectation = expectationWithDescription("tests deleting a chat message by id")
        
        BeamClient.sharedClient.chat.deleteChatMessage(channelId, messageId: messageId) { (error) in
            XCTAssert(error == .NotAuthenticated)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testChatDetailsById() {
        let expectation = expectationWithDescription("tests retrieving chat details")
        
        BeamClient.sharedClient.chat.getChatDetailsById(channelId) { (endpoints, authKey, error) in
            XCTAssertNotNil(endpoints)
            XCTAssertNil(authKey)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testViewersByChannel() {
        let expectation = expectationWithDescription("tests retrieving viewers of a channel")
        
        BeamClient.sharedClient.chat.getViewersByChannel(channelId) { (users, error) in
            XCTAssertNotNil(users)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testViewersByChannelWithQuery() {
        let expectation = expectationWithDescription("tests retrieving viewers of a channel by query")
        
        BeamClient.sharedClient.chat.getViewersByChannelWithQuery(channelId, query: query) { (users, error) in
            XCTAssertNotNil(users)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testSpacesuit() {
        let spacesuit = BeamClient.sharedClient.chat.getSpaceSuit(userId)
        XCTAssertNotNil(spacesuit)
    }
}
