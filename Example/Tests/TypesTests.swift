//
//  TypesTests.swift
//  MixerAPI
//
//  Created by Jack Cook on 7/15/16.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//

import MixerAPI
import XCTest

class TypesTests: XCTestCase {
    
    let query = "aaaa"
    let typeId = 33217
    
    func testTypeWithId() {
        let expectation = self.expectation(description: "tests retrieving a type by id")
        
        MixerClient.sharedClient.types.getTypeWithId(typeId) { (type, error) in
            XCTAssertNotNil(type)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testTypes() {
        let expectation = self.expectation(description: "tests retrieving types")
        
        MixerClient.sharedClient.types.getTypes { (types, error) in
            XCTAssertNotNil(types)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testTypesByQuery() {
        let expectation = self.expectation(description: "tests searching for types")
        
        MixerClient.sharedClient.types.getTypesByQuery(query) { (types, error) in
            XCTAssertNotNil(types)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
