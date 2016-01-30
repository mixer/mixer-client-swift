//
//  UserTests.swift
//  BeamAPI
//
//  Created by Jack Cook on 1/30/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import BeamAPI
import XCTest

class UserTests: XCTestCase {
    
    let userId = 278
    
    func testChannelsFollowedByUser() {
        let expectation = expectationWithDescription("tests retreving the channels followed by a user")
        
        BeamClient.sharedClient.users.getFollowedChannelsByUser(userId) { (channels, error) -> Void in
            guard let _ = channels else {
                XCTFail()
                return
            }
            
            XCTAssert(error == nil)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testUserWithID() {
        let expectation = expectationWithDescription("tests retrieving a user with id")
        
        BeamClient.sharedClient.users.getUserWithId(userId) { (user, error) -> Void in
            guard let _ = user else {
                XCTFail()
                return
            }
            
            XCTAssert(error == nil)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testUsersByQuery() {
        let expectation = expectationWithDescription("tests searching for users")
        
        BeamClient.sharedClient.users.getUsersByQuery("aaa") { (users, error) -> Void in
            guard let _ = users else {
                XCTFail()
                return
            }
            
            XCTAssert(error == nil)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
}
