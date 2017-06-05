//
//  SessionTests.swift
//  MixerAPI
//
//  Created by Jack Cook on 1/30/16.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//

import MixerAPI
import XCTest

class SessionTests: XCTestCase {
    
    var username: String!
    let invalidUsername = "xcz"
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
            let string = random.substring(with: range).lowercased()
            return "a" + string.replacingOccurrences(of: "-", with: "")
        }
        
        username = genRandomString()
        password = genRandomString()
    }
    
    override func tearDown() {
        super.tearDown()
        
        MixerSession.logout(nil)
    }
    
    func testAuthenticate() {
        let expectation = self.expectation(description: "tests authenticating")
        
        MixerSession.authenticate(username, password: password) { (user, error) in
            XCTAssertNil(user)
            XCTAssert(error == .invalidCredentials)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testAuthenticateWithCode() {
        let expectation = self.expectation(description: "tests authenticating with 2fa")
        
        MixerSession.authenticate(username, password: password, code: code) { (user, error) in
            XCTAssertNil(user)
            XCTAssert(error == .invalidCredentials)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testLogout() {
        let expectation = self.expectation(description: "tests logging out")
        
        MixerSession.logout { (error) in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testRegisterTakenUsername() {
        let expectation = self.expectation(description: "tests the registration endpoint for the taken username error")
        
        MixerSession.registerAccount(takenUsername, password: password, email: email) { (user, error) in
            XCTAssert(error == .takenUsername)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testRegisterWeakPassword() {
        let expectation = self.expectation(description: "tests the registration endpoint for the weak password error")
        
        MixerSession.registerAccount(username, password: weakPassword, email: email) { (user, error) in
            XCTAssert(error == .weakPassword)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testRegisterInvalidEmail() {
        let expectation = self.expectation(description: "tests the registration endpoint for the invalid email error")
        
        MixerSession.registerAccount(username, password: password, email: invalidEmail) { (user, error) in
            XCTAssert(error == .invalidEmail)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testRegisterTakenEmail() {
        let expectation = self.expectation(description: "tests the registration endpoint for the taken email error")
        
        MixerSession.registerAccount(username, password: password, email: takenEmail) { (user, error) in
            XCTAssert(error == .takenEmail)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
