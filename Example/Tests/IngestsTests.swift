//
//  IngestsTests.swift
//  BeamAPI
//
//  Created by Jack Cook on 7/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import BeamAPI
import XCTest

class IngestsTests: XCTestCase {
    
    func testsIngests() {
        let expectation = self.expectation(description: "tests the ingests endpoint")
        
        BeamClient.sharedClient.ingests.getIngests { (ingests, error) in
            XCTAssertNotNil(ingests)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
