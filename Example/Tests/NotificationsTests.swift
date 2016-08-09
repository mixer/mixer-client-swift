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
    
    let transport = "push"
    let transportId = 840858
    let userId = 278
    
    func testsMarkNotificationsAsRead() {
        let expectation = expectationWithDescription("tests marking notifications as read")
        
        BeamClient.sharedClient.notifications.markNotificationsAsRead(userId, beforeDate: NSDate()) { (error) in
            XCTAssert(error == .InvalidCredentials)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testsUpdateTransport() {
        let expectation = expectationWithDescription("tests the updating a notification transport endpoint")
        
        BeamClient.sharedClient.notifications.updateNotificationTransport(userId, transport: transport, data: nil, settings: nil) { (transport, error) in
            XCTAssertNil(transport)
            XCTAssert(error == .InvalidCredentials)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testsDeleteTransport() {
        let expectation = expectationWithDescription("tests the delete transport endpoint")
        
        BeamClient.sharedClient.notifications.deleteNotificationTransport(userId, transportId: transportId) { (error) in
            XCTAssert(error == .InvalidCredentials)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testsNotifications() {
        let expectation = expectationWithDescription("tests the notifications endpoint")
        
        BeamClient.sharedClient.notifications.getNotifications(userId) { (notifications, error) in
            XCTAssertNil(notifications)
            XCTAssert(error == .InvalidCredentials)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testsNotificationTransports() {
        let expectation = expectationWithDescription("tests the notification transports endpoint")
        
        BeamClient.sharedClient.notifications.getNotificationTransports(userId) { (transports, error) in
            XCTAssertNil(transports)
            XCTAssert(error == .InvalidCredentials)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
}
