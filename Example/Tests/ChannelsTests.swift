//
//  ChannelTests.swift
//  BeamAPI
//
//  Created by Jack Cook on 1/30/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import BeamAPI
import XCTest

class ChannelsTests: XCTestCase {
    
    let channelId = 3181
    let channelToken = "jack"
    let query = "aaaa"
    let typeId = 33217
    let userId = 278
    
    func testFollowChannel() {
        let expectation = expectationWithDescription("tests the follow channel endpoint")
        
        BeamClient.sharedClient.channels.followChannel(channelId) { (error) in
            
            
            XCTAssert(error == .NotAuthenticated)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testUnfollowChannel() {
        let expectation = expectationWithDescription("tests the unfollow channel endpoint")
        
        BeamClient.sharedClient.channels.unfollowChannel(channelId) { (error) in
            XCTAssert(error == .NotAuthenticated)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testBanUser() {
        let expectation = expectationWithDescription("tests banning a user from chat")
        
        BeamClient.sharedClient.channels.banUser(channelId, userId: userId) { (error) in
            XCTAssert(error == .NotAuthenticated)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testUnbanUser() {
        let expectation = expectationWithDescription("tests unbanning a user from chat")
        
        BeamClient.sharedClient.channels.unbanUser(channelId, userId: userId) { (error) in
            XCTAssert(error == .NotAuthenticated)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testChannelWithId() {
        let expectation = expectationWithDescription("tests retrieving a channel by id")
        
        BeamClient.sharedClient.channels.getChannelWithId(channelId) { (channel, error) in
            XCTAssertNotNil(channel)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testChannelWithToken() {
        let expectation = expectationWithDescription("tests retrieving a channel by token")
        
        BeamClient.sharedClient.channels.getChannelWithToken(channelToken) { (channel, error) in
            XCTAssertNotNil(channel)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testChannels() {
        let expectation = expectationWithDescription("tests the default channels endpoint")
        
        var i = 0
        
        for req in [ChannelsRoutes.ChannelsRequestType.All, .Interactive, .Rising, .Fresh] {
            BeamClient.sharedClient.channels.getChannels(req) { (channels, error) in
                XCTAssertNotNil(channels)
                XCTAssertNil(error)
                
                i += 1
                
                if i == 4 {
                    expectation.fulfill()
                }
            }
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testChannelsByQuery() {
        let expectation = expectationWithDescription("tests searching for channels")
        
        BeamClient.sharedClient.channels.getChannelsByQuery(query) { (channels, error) in
            XCTAssertNotNil(channels)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testTypeWithId() {
        let expectation = expectationWithDescription("tests retrieving a type by id")
        
        BeamClient.sharedClient.channels.getTypeWithId(typeId) { (type, error) in
            XCTAssertNotNil(type)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testTypes() {
        let expectation = expectationWithDescription("tests retrieving types")
        
        BeamClient.sharedClient.channels.getTypes { (types, error) in
            XCTAssertNotNil(types)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testTypesByQuery() {
        let expectation = expectationWithDescription("tests searching for types")
        
        BeamClient.sharedClient.channels.getTypesByQuery(query) { (types, error) in
            XCTAssertNotNil(types)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testFollowersOfChannel() {
        let expectation = expectationWithDescription("tests retrieving a channel's followers")
        
        BeamClient.sharedClient.channels.getFollowersOfChannel(channelId) { (users, error) in
            XCTAssertNotNil(users)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testEmoticonsOfChannel() {
        let expectation = expectationWithDescription("tests retrieving a channel's emoticons")
        
        BeamClient.sharedClient.channels.getEmoticonsOfChannel(channelId) { (spritesheetUrl, emoticons, error) in
            XCTAssertNotNil(spritesheetUrl)
            XCTAssertNotNil(emoticons)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testsRecordingsOfChannel() {
        let expectation = expectationWithDescription("tests retrieving recordings from a channel")
        
        BeamClient.sharedClient.channels.getRecordingsOfChannel(channelId) { (recordings, error) in
            XCTAssertNotNil(recordings)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testUpdateData() {
        let expectation = expectationWithDescription("tests updating chnanel data")
        
        BeamClient.sharedClient.channels.updateData(channelId, body: []) { (channel, error) in
            XCTAssertNil(channel)
            XCTAssert(error == .NotAuthenticated)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
}
