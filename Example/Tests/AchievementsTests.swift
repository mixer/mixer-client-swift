//
//  Achievement.swift
//  MixerAPI
//
//  Created by Jack Cook on 1/30/16.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//

import MixerAPI
import XCTest

class AchievementsTests: XCTestCase {
    
    let userId = 278
    
    func testAchievements() {
        let expectation = self.expectation(description: "tests the achievements endpoint")
        
        MixerClient.sharedClient.achievements.getAchievements { (achievements, error) in
            XCTAssertNotNil(achievements)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
