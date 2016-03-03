//
//  TetrisTests.swift
//  BeamAPI
//
//  Created by Jack Cook on 3/3/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import BeamAPI
import SwiftyJSON
import XCTest

class TetrisTests: XCTestCase {
    
    var channel: BeamChannel!
    
    override func setUp() {
        super.setUp()
        
        let semaphore = dispatch_semaphore_create(0)
        
        BeamRequest.request("/channels", requestType: "GET", params: ["where": "interactive.eq.1"]) { (json, error) -> Void in
            guard let json = json,
                let channels = json.array else {
                    XCTFail()
                    return
            }
            
            var retrievedChannels = [BeamChannel]()
            
            for channel in channels {
                let retrievedChannel = BeamChannel(json: channel)
                retrievedChannels.append(retrievedChannel)
            }
            
            guard retrievedChannels.count > 0 else {
                XCTFail()
                return
            }
            
            XCTAssert(error == nil)
            self.channel = retrievedChannels[0]
            
            dispatch_semaphore_signal(semaphore)
        }
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
    }
    
    func testTetrisData() {
        let expectation = expectationWithDescription("tests the tetris data endpoint")
        
        BeamClient.sharedClient.tetris.getTetrisDataByChannel(channel.id) { (data, error) -> Void in
            guard let _ = data else {
                XCTFail()
                return
            }
            
            XCTAssert(error == nil)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
}
