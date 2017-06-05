//
//  OAuthTests.swift
//  MixerAPI
//
//  Created by Jack Cook on 7/14/16.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//

import MixerAPI
import XCTest

class OAuthTests: XCTestCase {
    
    override func tearDown() {
        super.tearDown()
        
        MixerSession.logout(nil)
    }
    
    func testAuthorizationURL() {
        XCTAssertNotNil(MixerClient.sharedClient.oauth.getAuthorizationURL(.Twitter))
        XCTAssertNotNil(MixerClient.sharedClient.oauth.getAuthorizationURL(.Discord))
    }
    
    func testLoginWithProvider() {
        let expectation = self.expectation(description: "tests logging in through an oauth provider")
        
        var i = 0
        
        for provider in [OAuthRoutes.OAuthProvider.Twitter, .Discord] {
            MixerClient.sharedClient.oauth.loginWithProvider(provider, cookie: "") { (user, error) in
                XCTAssertNil(user)
                XCTAssert(error == .invalidCredentials)
                
                i += 1
                
                if i == 2 {
                    expectation.fulfill()
                }
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
