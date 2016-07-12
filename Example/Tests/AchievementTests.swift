//
//  Achievement.swift
//  BeamAPI
//
//  Created by Jack Cook on 1/30/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import BeamAPI
import UIKit
import XCTest

class AchievementTests: XCTestCase {
    
    let userId = 278
    
    func testAchievements() {
        let expectation = expectationWithDescription("tests the achievements endpoint")
        
        BeamClient.sharedClient.achievements.getAchievements { (achievements, error) -> Void in
            guard let _ = achievements else {
                XCTFail()
                return
            }
            
            XCTAssert(error == nil)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
}
