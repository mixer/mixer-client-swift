//
//  InteractiveTests.swift
//  MixerAPI
//
//  Created by Jack Cook on 3/3/16.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//

import MixerAPI
import XCTest

class InteractiveTests: XCTestCase {
    
    let channelId = 3783781
    
    func testInteractiveData() {
        let expectation = self.expectation(description: "tests the interactive data endpoint")
        
        MixerClient.sharedClient.interactive.getInteractiveDataByChannel(channelId) { (data, error) in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
