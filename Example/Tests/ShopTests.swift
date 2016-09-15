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
    
    let categoryId = 1
    let itemId = 1
    
    func testCategories() {
        let expectation = self.expectation(description: "tests the categories endpoint")
        
        BeamClient.sharedClient.shop.getCategories { (categories, error) in
            XCTAssertNotNil(categories)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testItemsByCategory() {
        let expectation = self.expectation(description: "tests retrieving items from a category")
        
        BeamClient.sharedClient.shop.getItemsByCategory(categoryId) { (items, error) in
            XCTAssertNotNil(items)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testItemWithId() {
        let expectation = self.expectation(description: "tests retrieving an item by id")
        
        BeamClient.sharedClient.shop.getItemWithId(itemId) { (item, error) in
            XCTAssertNotNil(item)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
