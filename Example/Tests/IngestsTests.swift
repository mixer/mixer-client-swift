//
//  IngestsTests.swift
//  MixerAPI
//
//  Created by Jack Cook on 7/12/16.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//

import MixerAPI
import XCTest

class IngestsTests: XCTestCase {
    
    func testsIngests() {
        let expectation = self.expectation(description: "tests the ingests endpoint")
        
        MixerClient.sharedClient.ingests.getIngests { (ingests, error) in
            XCTAssertNotNil(ingests)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
