//
//  SessionTests.swift
//  BeamAPI
//
//  Created by Jack Cook on 1/30/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import BeamAPI
import XCTest

class SessionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        let semaphore = dispatch_semaphore_create(0)
        
        BeamSession.authenticate("beamtest", password: "NYCjack123") { (user, error) -> Void in
            guard let _ = user else {
                XCTFail()
                return
            }
            
            XCTAssert(error == nil)
            dispatch_semaphore_signal(semaphore)
        }
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
    }
    
    override func tearDown() {
        super.tearDown()
        
        let semaphore = dispatch_semaphore_create(0)
        
        BeamSession.logout { (error) -> Void in
            XCTAssert(error == nil)
            dispatch_semaphore_signal(semaphore)
        }
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
    }
    
    func testRefresh() {
        let expectation = expectationWithDescription("tests the refresh endpoint")
        
        BeamSession.refreshPreviousSession { (user, error) -> Void in
            guard let _ = user else {
                XCTFail()
                return
            }
            
            XCTAssert(error == nil)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
}
