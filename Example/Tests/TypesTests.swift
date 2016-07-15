//
//  TypesTests.swift
//  BeamAPI
//
//  Created by Jack Cook on 7/15/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import BeamAPI
import XCTest

class TypesTests: XCTestCase {
    
    let query = "aaaa"
    let typeId = 33217
    
    func testTypeWithId() {
        let expectation = expectationWithDescription("tests retrieving a type by id")
        
        BeamClient.sharedClient.types.getTypeWithId(typeId) { (type, error) in
            XCTAssertNotNil(type)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testTypes() {
        let expectation = expectationWithDescription("tests retrieving types")
        
        BeamClient.sharedClient.types.getTypes { (types, error) in
            XCTAssertNotNil(types)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testTypesByQuery() {
        let expectation = expectationWithDescription("tests searching for types")
        
        BeamClient.sharedClient.types.getTypesByQuery(query) { (types, error) in
            XCTAssertNotNil(types)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
}
