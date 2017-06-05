//
//  NotificationsTests.swift
//  MixerAPI
//
//  Created by Jack Cook on 8/9/16.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//

import MixerAPI
import SwiftyJSON
import XCTest

class NotificationsTests: XCTestCase {
    
    func testsRetrieveNotificationPreferences() {
        let expectation = self.expectation(description: "tests retrieving a user's notification preferences")
        
        MixerClient.sharedClient.notifications.getNotificationPreferences { (preferences, error) in
            XCTAssert(error == .notAuthenticated)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
