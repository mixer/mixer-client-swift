//
//  NotificationsTests.swift
//  BeamAPI
//
//  Created by Jack Cook on 8/9/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import BeamAPI
import SwiftyJSON
import XCTest

class NotificationsTests: XCTestCase {
    
    func testsRetrieveNotificationPreferences() {
        let expectation = self.expectation(description: "tests retrieving a user's notification preferences")
        
        BeamClient.sharedClient.notifications.getNotificationPreferences { (preferences, error) in
            XCTAssert(error == .notAuthenticated)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
