//
//  NotificationsTests.swift
//  BeamAPI
//
//  Created by Jack Cook on 8/9/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import BeamAPI
import XCTest

class NotificationsTests: XCTestCase {
    
    let userId = 278
    
    func testsNotifications() {
        let expectation = expectationWithDescription("tests the notifications endpoint")
        
        BeamClient.sharedClient.notifications.getNotifications(userId) { (notifications, error) in
            XCTAssertNil(notifications)
            XCTAssert(error == .InvalidCredentials)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
}
