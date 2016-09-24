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
        let expectation = self.expectation(description: "tests marking notifications as read")
        
        BeamClient.sharedClient.notifications.markNotificationsAsRead(userId, beforeDate: Date()) { (error) in
            XCTAssert(error == .invalidCredentials)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testsUpdateTransport() {
        let expectation = self.expectation(description: "tests the updating a notification transport endpoint")
        
        BeamClient.sharedClient.notifications.updateNotificationTransport(userId, transport: transport, data: nil, settings: nil) { (transport, error) in
            XCTAssertNil(transport)
            XCTAssert(error == .invalidCredentials)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testsDeleteTransport() {
        let expectation = self.expectation(description: "tests the delete transport endpoint")
        
        BeamClient.sharedClient.notifications.deleteNotificationTransport(userId, transportId: transportId) { (error) in
            XCTAssert(error == .invalidCredentials)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testsNotifications() {
        let expectation = self.expectation(description: "tests the notifications endpoint")
        
        BeamClient.sharedClient.notifications.getNotifications(userId) { (notifications, error) in
            XCTAssertNil(notifications)
            XCTAssert(error == .invalidCredentials)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testsNotificationTransports() {
        let expectation = self.expectation(description: "tests the notification transports endpoint")
        
        BeamClient.sharedClient.notifications.getNotificationTransports(userId) { (transports, error) in
            XCTAssertNil(transports)
            XCTAssert(error == .invalidCredentials)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
