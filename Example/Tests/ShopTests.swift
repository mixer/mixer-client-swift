//
//  ShopTests.swift
//  BeamAPI
//
//  Created by Jack Cook on 1/30/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import BeamAPI
import XCTest

class ShopTests: XCTestCase {
    
    func testCategories() {
        let expectation = expectationWithDescription("tests the categories endpoint")
        
        BeamClient.sharedClient.shop.getCategories { (categories, error) -> Void in
            guard let _ = categories else {
                XCTFail()
                return
            }
            
            XCTAssert(error == nil)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testItemsByCategory() {
        let expectation = expectationWithDescription("tests retrieving items by a category")
        
        BeamClient.sharedClient.shop.getItemsByCategory(1) { (items, error) -> Void in
            guard let _ = items else {
                XCTFail()
                return
            }
            
            XCTAssert(error == nil)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }

//    there currently are no shop items
//    func testItemWithId() {
//        let expectation = expectationWithDescription("tests retrieving an item by id")
//        
//        BeamClient.sharedClient.shop.getItemWithId(1) { (item, error) -> Void in
//            guard let _ = item else {
//                XCTFail()
//                return
//            }
//            
//            XCTAssert(error == nil)
//            expectation.fulfill()
//        }
//        
//        waitForExpectationsWithTimeout(10, handler: nil)
//    }
}
