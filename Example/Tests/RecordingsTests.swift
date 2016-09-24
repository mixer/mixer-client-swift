//
//  RecordingsTests.swift
//  BeamAPI
//
//  Created by Jack Cook on 7/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import BeamAPI
import XCTest

class RecordingsTests: XCTestCase {
    
    let channelId = 3181
    var recordingId: Int!
    
    override func setUp() {
        super.setUp()
        
        let semaphore = DispatchSemaphore(value: 0)
        
        BeamClient.sharedClient.channels.getRecordingsOfChannel(channelId) { (recordings, error) in
            guard let id = recordings?[0].id else {
                XCTFail()
                return
            }
            
            XCTAssertNil(error)
            
            self.recordingId = id
            
            semaphore.signal()
        }
        
        let _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
    
    func testsRecordingSeen() {
        let expectation = self.expectation(description: "tests marking a recording as seen")
        
        BeamClient.sharedClient.recordings.markRecordingSeen(recordingId) { (error) in
            XCTAssert(error == .notAuthenticated)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testsRecording() {
        let expectation = self.expectation(description: "tests retrieving a recording")
        
        BeamClient.sharedClient.recordings.getRecording(recordingId) { (recording, error) in
            XCTAssertNotNil(recording)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
