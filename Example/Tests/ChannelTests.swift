//
//  ChannelTests.swift
//  BeamAPI
//
//  Created by Jack Cook on 1/30/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import BeamAPI
import UIKit
import XCTest

class ChannelTests: XCTestCase {
    
    let channelId = 252
    let channelToken = "jack"
    let typeId = 33217
    
    func testDefaultChannels() {
        let expectation = expectationWithDescription("tests the default channels endpoint")
        
        BeamClient.sharedClient.channels.getDefaultChannels { (channels, error) -> Void in
            guard let _ = channels else {
                XCTFail()
                return
            }
            
            XCTAssert(error == nil)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testChannelWithID() {
        let expectation = expectationWithDescription("tests retrieving a channel by id")
        
        BeamClient.sharedClient.channels.getChannelWithId(channelId) { (channel, error) -> Void in
            guard let _ = channel else {
                XCTFail()
                return
            }
            
            XCTAssert(error == nil)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testChannelWithToken() {
        let expectation = expectationWithDescription("tests retrieving a channel by token")
        
        BeamClient.sharedClient.channels.getChannelWithToken(channelToken) { (channel, error) -> Void in
            guard let _ = channel else {
                XCTFail()
                return
            }
            
            XCTAssert(error == nil)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testChannelsByQuery() {
        let expectation = expectationWithDescription("tests searching for channels")
        
        BeamClient.sharedClient.channels.getChannelsByQuery("aaa") { (channels, error) -> Void in
            guard let _ = channels else {
                XCTFail()
                return
            }
            
            XCTAssert(error == nil)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testChannelsByType() {
        let expectation = expectationWithDescription("tests retrieving channels by game")
        
        BeamClient.sharedClient.channels.getChannelsByType(typeId) { (channels, error) -> Void in
            guard let _ = channels else {
                XCTFail()
                return
            }
            
            XCTAssert(error == nil)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testTypes() {
        let expectation = expectationWithDescription("tests retrieving types")
        
        BeamClient.sharedClient.channels.getTypes { (types, error) -> Void in
            guard let _ = types else {
                XCTFail()
                return
            }
            
            XCTAssert(error == nil)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
}
