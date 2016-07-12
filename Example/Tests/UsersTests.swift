//
//  UserTests.swift
//  BeamAPI
//
//  Created by Jack Cook on 1/30/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import BeamAPI
import XCTest

class UsersTests: XCTestCase {
    
    let email = "hello@test.com"
    let query = "aaaa"
    let userId = 278
    
    func testForgotPassword() {
        let expectation = expectationWithDescription("tests forgot password endpoint")
        
        BeamClient.sharedClient.users.forgotPassword(email) { (error) in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testUpdatePreferences() {
        let expectation = expectationWithDescription("tests updating a user's preferences")
        
        BeamClient.sharedClient.users.updatePreferences(userId, preferences: []) { (error) in
            XCTAssert(error == .NotAuthenticated)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testUpdateProfile() {
        let expectation = expectationWithDescription("tests updating a user's profile")
        
        BeamClient.sharedClient.users.updateProfile(userId, settings: []) { (user, error) in
            XCTAssertNil(user)
            XCTAssert(error == .NotAuthenticated)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testUserAchievements() {
        let expectation = expectationWithDescription("tests retrieving a user's achievements")
        
        BeamClient.sharedClient.users.getAchievementsByUser(userId) { (achievements, error) in
            XCTAssertNotNil(achievements)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testUserFollowedChannels() {
        let expectation = expectationWithDescription("tests retreving a user's followed channels")
        
        BeamClient.sharedClient.users.getFollowedChannelsByUser(userId) { (channels, error) in
            XCTAssertNotNil(channels)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testPreferences() {
        let expectation = expectationWithDescription("tests retrieving a user's preferences")
        
        BeamClient.sharedClient.users.getPreferences(userId) { (preferences, error) in
            XCTAssertNotNil(preferences)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testUserWithId() {
        let expectation = expectationWithDescription("tests retrieving a user by id")
        
        BeamClient.sharedClient.users.getUserWithId(userId) { (user, error) in
            XCTAssertNotNil(user)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testUsersByQuery() {
        let expectation = expectationWithDescription("tests searching for users")
        
        BeamClient.sharedClient.users.getUsersByQuery(query) { (users, error) in
            XCTAssertNotNil(users)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
}
