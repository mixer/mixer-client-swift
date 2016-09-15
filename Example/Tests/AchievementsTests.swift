//
//  Achievement.swift
//  BeamAPI
//
//  Created by Jack Cook on 1/30/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import BeamAPI
import XCTest

class AchievementsTests: XCTestCase {
    
    let userId = 278
    
    func testAchievements() {
        let expectation = self.expectation(description: "tests the achievements endpoint")
        
        BeamClient.sharedClient.achievements.getAchievements { (achievements, error) in
            XCTAssertNotNil(achievements)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
