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
        
        BeamClient.sharedClient.channels.getChannels(.All, offset: 0) { (channels, error) in
            guard let channels = channels else {
                XCTFail()
                return
            }
            
            for channel in channels where channel.interactive {
                self.channel = channel
                break
            }
            
            guard self.channel != nil else {
                XCTFail()
                return
            }
            
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
