//
//  RecordingsTests.swift
//  MixerAPI
//
//  Created by Jack Cook on 7/12/16.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//

import MixerAPI
import XCTest

class RecordingsTests: XCTestCase {
    
    let channelId = 3181
    var recordingId: Int!
    
    override func setUp() {
        super.setUp()
        
        let semaphore = DispatchSemaphore(value: 0)
        
        MixerClient.sharedClient.channels.getRecordingsOfChannel(channelId) { (recordings, error) in
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
        
        MixerClient.sharedClient.recordings.markRecordingSeen(recordingId) { (error) in
            XCTAssert(error == .notAuthenticated)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testsRecording() {
        let expectation = self.expectation(description: "tests retrieving a recording")
        
        MixerClient.sharedClient.recordings.getRecording(recordingId) { (recording, error) in
            XCTAssertNotNil(recording)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
