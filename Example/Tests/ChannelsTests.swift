//
//  ChannelTests.swift
//  MixerAPI
//
//  Created by Jack Cook on 1/30/16.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//

import MixerAPI
import XCTest

class ChannelsTests: XCTestCase {
    
    let channelId = 3181
    let channelToken = "jack"
    let query = "aaaa"
    let userId = 278
    
    func testFollowChannel() {
        let expectation = self.expectation(description: "tests the follow channel endpoint")
        
        MixerClient.sharedClient.channels.followChannel(channelId) { (error) in
            XCTAssert(error == .notAuthenticated)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testUnfollowChannel() {
        let expectation = self.expectation(description: "tests the unfollow channel endpoint")
        
        MixerClient.sharedClient.channels.unfollowChannel(channelId) { (error) in
            XCTAssert(error == .notAuthenticated)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testBanUser() {
        let expectation = self.expectation(description: "tests banning a user from chat")
        
        MixerClient.sharedClient.channels.banUser(channelId, userId: userId) { (error) in
            XCTAssert(error == .notAuthenticated)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testUnbanUser() {
        let expectation = self.expectation(description: "tests unbanning a user from chat")
        
        MixerClient.sharedClient.channels.unbanUser(channelId, userId: userId) { (error) in
            XCTAssert(error == .notAuthenticated)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testHostChannel() {
        let expectation = self.expectation(description: "tests hosting a channel")
        
        MixerClient.sharedClient.channels.hostChannel(channelId) { (error) in
            XCTAssert(error == .notAuthenticated)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testStopHosting() {
        let expectation = self.expectation(description: "tests stopping hosting")
        
        MixerClient.sharedClient.channels.stopHosting { (error) in
            XCTAssert(error == .notAuthenticated)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testChannelWithId() {
        let expectation = self.expectation(description: "tests retrieving a channel by id")
        
        MixerClient.sharedClient.channels.getChannelWithId(channelId) { (channel, error) in
            XCTAssertNotNil(channel)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testChannelWithToken() {
        let expectation = self.expectation(description: "tests retrieving a channel by token")
        
        MixerClient.sharedClient.channels.getChannelWithToken(channelToken) { (channel, error) in
            XCTAssertNotNil(channel)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testChannels() {
        let expectation = self.expectation(description: "tests the default channels endpoint")
        
        var i = 0
        
        for req in [ChannelsRoutes.ChannelsRequestType.all, .interactive, .rising, .fresh] {
            MixerClient.sharedClient.channels.getChannels(req) { (channels, error) in
                XCTAssertNotNil(channels)
                XCTAssertNil(error)
                
                i += 1
                
                if i == 4 {
                    expectation.fulfill()
                }
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testChannelsByQuery() {
        let expectation = self.expectation(description: "tests searching for channels")
        
        MixerClient.sharedClient.channels.getChannelsByQuery(query) { (channels, error) in
            XCTAssertNotNil(channels)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFollowersOfChannel() {
        let expectation = self.expectation(description: "tests retrieving a channel's followers")
        
        MixerClient.sharedClient.channels.getFollowersOfChannel(channelId) { (users, error) in
            XCTAssertNotNil(users)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testEmoticonsOfChannel() {
        let expectation = self.expectation(description: "tests retrieving a channel's emoticons")
        
        MixerClient.sharedClient.channels.getEmoticonsOfChannel(channelId) { (spritesheetUrl, emoticons, error) in
            XCTAssertNotNil(spritesheetUrl)
            XCTAssertNotNil(emoticons)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testRecordingsOfChannel() {
        let expectation = self.expectation(description: "tests retrieving recordings from a channel")
        
        MixerClient.sharedClient.channels.getRecordingsOfChannel(channelId) { (recordings, error) in
            XCTAssertNotNil(recordings)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testDefaultEmoticons() {
        let expectation = self.expectation(description: "tests retrieving the default Mixer emoticons")
        
        MixerClient.sharedClient.channels.getDefaultEmoticons { (packs, error) in
            XCTAssertNotNil(packs)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testUpdateData() {
        let expectation = self.expectation(description: "tests updating chnanel data")
        
        MixerClient.sharedClient.channels.updateData(channelId, body: [] as AnyObject) { (channel, error) in
            XCTAssertNil(channel)
            XCTAssert(error == .notAuthenticated)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
