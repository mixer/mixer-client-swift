//
//  InteractiveTests.swift
//  BeamAPI
//
//  Created by Jack Cook on 3/3/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import BeamAPI
import XCTest

class InteractiveTests: XCTestCase {
    
    let channelId = 50772
    
    func testInteractiveData() {
        let expectation = expectationWithDescription("tests the Interactive data endpoint")
        
        BeamClient.sharedClient.Interactive.getInteractiveDataByChannel(channelId) { (data, error) in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
}
