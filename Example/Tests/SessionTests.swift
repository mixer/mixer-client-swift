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
    
    func testRefresh() {
        let expectation = expectationWithDescription("tests the refresh endpoint")
        
        BeamSession.authenticate("beamtest", password: "NYCjack123") { (user, error) -> Void in
            guard let _ = user else {
                XCTFail()
                return
            }
            
            BeamSession.refreshPreviousSession { (user, error) -> Void in
                guard let _ = user else {
                    XCTFail()
                    return
                }
                
                XCTAssert(error == nil)
                expectation.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testRegisterInvalidUsername() {
        let expectation = expectationWithDescription("tests the registration endpoint for the invalid username error")
        
        BeamSession.registerAccount("a", password: "NYCjack123", email: "beam@email.com") { (user, error) -> Void in
            XCTAssert(error == .InvalidUsername)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testRegisterTakenUsername() {
        let expectation = expectationWithDescription("tests the registration endpoint for the taken username error")
        
        BeamSession.registerAccount("beamtest", password: "NYCjack123", email: "beam@email.com") { (user, error) -> Void in
            XCTAssert(error == .TakenUsername)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testRegisterWeakPassword() {
        let expectation = expectationWithDescription("tests the registration endpoint for the weak password error")
        
        BeamSession.registerAccount("xozicvioxzcv", password: "aaaaa", email: "beam@email.com") { (user, error) -> Void in
            XCTAssert(error == .WeakPassword)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testRegisterInvalidEmail() {
        let expectation = expectationWithDescription("tests the registration endpoint for the invalid email error")
        
        BeamSession.registerAccount("xozicvioxzcv", password: "NYCjack123", email: "test") { (user, error) -> Void in
            XCTAssert(error == .InvalidEmail)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testRegisterTakenEmail() {
        let expectation = expectationWithDescription("tests the registration endpoint for the taken email error")
        
        BeamSession.registerAccount("xozicvioxzcv", password: "NYCjack123", email: "do1@jackcook.nyc") { (user, error) -> Void in
            XCTAssert(error == .TakenEmail)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
}
