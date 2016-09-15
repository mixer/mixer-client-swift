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
    
    var username: String!
    let invalidUsername = "a"
    let takenUsername = "beamtest"
    
    var password: String!
    var weakPassword = "aaaa"
    
    let email = "hello@test.com"
    let invalidEmail = "aaaa"
    let takenEmail = "do1@jackcook.nyc"
    
    let code = 111111
    
    override func setUp() {
        super.setUp()
        
        func genRandomString() -> String {
            let random = UUID().uuidString
            let range = random.startIndex ..< random.characters.index(random.startIndex, offsetBy: 12)
            let string = random.substringWithRange(range).lowercased()
            return "a" + string.replacingOccurrences(of: "-", with: "")
        }
        
        username = genRandomString()
        password = genRandomString()
    }
    
    override func tearDown() {
        super.tearDown()
        
        BeamSession.logout(nil)
    }
    
    func testAuthenticate() {
        let expectation = self.expectation(description: "tests authenticating")
        
        BeamSession.authenticate(username, password: password) { (user, error) in
            XCTAssertNil(user)
            XCTAssert(error == .InvalidCredentials)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testAuthenticateWithCode() {
        let expectation = self.expectation(description: "tests authenticating with 2fa")
        
        BeamSession.authenticate(username, password: password, code: code) { (user, error) in
            XCTAssertNil(user)
            XCTAssert(error == .InvalidCredentials)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testLogout() {
        let expectation = self.expectation(description: "tests logging out")
        
        BeamSession.logout { (error) in
            XCTAssert(error == .InvalidCredentials)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testRefreshPreviousSession() {
        let expectation = self.expectation(description: "tests the refresh endpoint")
        
        BeamSession.refreshPreviousSession { (user, error) in
            XCTAssertNil(user)
            XCTAssert(error == .NotAuthenticated)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testRegisterInvalidUsername() {
        let expectation = self.expectation(description: "tests the registration endpoint for the invalid username error")
        
        BeamSession.registerAccount(invalidUsername, password: password, email: email) { (user, error) in
            XCTAssert(error == .InvalidUsername)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testRegisterTakenUsername() {
        let expectation = self.expectation(description: "tests the registration endpoint for the taken username error")
        
        BeamSession.registerAccount(takenUsername, password: password, email: email) { (user, error) in
            XCTAssert(error == .TakenUsername)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testRegisterWeakPassword() {
        let expectation = self.expectation(description: "tests the registration endpoint for the weak password error")
        
        BeamSession.registerAccount(username, password: weakPassword, email: email) { (user, error) in
            XCTAssert(error == .WeakPassword)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testRegisterInvalidEmail() {
        let expectation = self.expectation(description: "tests the registration endpoint for the invalid email error")
        
        BeamSession.registerAccount(username, password: password, email: invalidEmail) { (user, error) in
            XCTAssert(error == .InvalidEmail)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testRegisterTakenEmail() {
        let expectation = self.expectation(description: "tests the registration endpoint for the taken email error")
        
        BeamSession.registerAccount(username, password: password, email: takenEmail) { (user, error) in
            XCTAssert(error == .TakenEmail)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
