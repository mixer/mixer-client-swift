//
//  OAuthTests.swift
//  BeamAPI
//
//  Created by Jack Cook on 7/14/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import BeamAPI
import XCTest

class OAuthTests: XCTestCase {
    
    override func tearDown() {
        super.tearDown()
        
        BeamSession.logout(nil)
    }
    
    func testAuthorizationURL() {
        XCTAssertNotNil(BeamClient.sharedClient.oauth.getAuthorizationURL(.Twitter))
        XCTAssertNotNil(BeamClient.sharedClient.oauth.getAuthorizationURL(.Discord))
    }
    
    func testLoginWithProvider() {
        let expectation = self.expectation(description: "tests logging in through an oauth provider")
        
        var i = 0
        
        for provider in [OAuthRoutes.OAuthProvider.Twitter, .Discord] {
            BeamClient.sharedClient.oauth.loginWithProvider(provider, cookie: "") { (user, error) in
                XCTAssertNil(user)
                XCTAssert(error == .InvalidCredentials)
                
                i += 1
                
                if i == 2 {
                    expectation.fulfill()
                }
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
