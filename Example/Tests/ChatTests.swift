//
//  ChatTests.swift
//  BeamAPI
//
//  Created by Jack Cook on 1/30/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import BeamAPI
import SwiftyJSON
import XCTest

class ChatTests: XCTestCase {
    
    var channel: BeamChannel!
    let userId = 278
    
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
    
    func testChatDetails() {
        let expectation = expectationWithDescription("tests retrieving chat details")
        
        BeamClient.sharedClient.chat.getChatDetailsById(channel.id) { (endpoints, authKey, error) -> Void in
            guard let _ = endpoints else {
                XCTFail()
                return
            }
            
            XCTAssert(authKey == nil)
            XCTAssert(error == nil)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testChatMessages() {
        let expectation = expectationWithDescription("tests retrieving cached messages")
        
        BeamClient.sharedClient.chat.getMessagesByChannel(channel.id) { (messages, error) -> Void in
            guard let _ = messages else {
                XCTFail()
                return
            }
            
            XCTAssert(error == nil)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testChatViewers() {
        let expectation = expectationWithDescription("tests retrieving viewers of a channel")
        
        BeamClient.sharedClient.chat.getViewersByChannel(channel.id) { (users, error) -> Void in
            guard let _ = users else {
                XCTFail()
                return
            }
            
            XCTAssert(error == nil)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testChatViewersByQuery() {
        let expectation = expectationWithDescription("tests retrieving viewers of a channel by query")
        
        BeamClient.sharedClient.chat.getViewersByChannelWithQuery(channel.id, query: "aaa") { (users, error) -> Void in
            guard let _ = users else {
                XCTFail()
                return
            }
            
            XCTAssert(error == nil)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testEmotion() {
        let expectation = expectationWithDescription("tests retrieving :( from the default emoticon pack")
        
        var component = BeamMessageComponent(json: JSON(""), me: false)
        component.source = "builtin"
        component.pack = "default"
        component.coordinates = CGPointMake(22, 44)
        
        BeamClient.sharedClient.chat.getEmoticon(component) { (emoticon, error) -> Void in
            guard let _ = emoticon else {
                XCTFail()
                return
            }
            
            XCTAssert(error == nil)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testSpacesuit() {
        let expectation = expectationWithDescription("tests retrieving a space suit")
        
        BeamClient.sharedClient.chat.getSpaceSuit(userId) { (spacesuit, error) -> Void in
            guard let _ = spacesuit else {
                XCTFail()
                return
            }
            
            XCTAssert(error == nil)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
}
