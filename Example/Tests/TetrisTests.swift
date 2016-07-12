//
//  TetrisTests.swift
//  BeamAPI
//
//  Created by Jack Cook on 3/3/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import BeamAPI
import XCTest

class TetrisTests: XCTestCase {
    
    let channelId = 50772
    
    func testTetrisData() {
        let expectation = expectationWithDescription("tests the tetris data endpoint")
        
        BeamClient.sharedClient.tetris.getTetrisDataByChannel(channelId) { (data, error) in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
}
