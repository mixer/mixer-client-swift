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
        
        let semaphore = dispatch_semaphore_create(0)
        
        BeamClient.sharedClient.recordings.getRecordingsByChannel(channelId) { (recordings, error) in
            guard let id = recordings?[0].id else {
                XCTFail()
                return
            }
            
            XCTAssertNil(error)
            
            self.recordingId = id
            
            dispatch_semaphore_signal(semaphore)
        }
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
    }
    
    func testsRecordingSeen() {
        let expectation = expectationWithDescription("tests marking a recording as seen")
        
        BeamClient.sharedClient.recordings.markRecordingSeen(recordingId) { (error) in
            XCTAssert(error == .NotAuthenticated)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testsRecording() {
        let expectation = expectationWithDescription("tests retrieving a recording")
        
        BeamClient.sharedClient.recordings.getRecording(recordingId) { (recording, error) in
            XCTAssertNotNil(recording)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testsRecordingsByChannel() {
        let expectation = expectationWithDescription("tests retrieving recordings from a channel")
        
        BeamClient.sharedClient.recordings.getRecordingsByChannel(channelId) { (recordings, error) in
            XCTAssertNotNil(recordings)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
}
