//
//  ShopTests.swift
//  MixerAPI
//
//  Created by Jack Cook on 1/30/16.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//

import MixerAPI
import XCTest

class ShopTests: XCTestCase {
    
    let categoryId = 1
    let itemId = 1
    
    func testCategories() {
        let expectation = self.expectation(description: "tests the categories endpoint")
        
        MixerClient.sharedClient.shop.getCategories { (categories, error) in
            XCTAssertNotNil(categories)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testItemsByCategory() {
        let expectation = self.expectation(description: "tests retrieving items from a category")
        
        MixerClient.sharedClient.shop.getItemsByCategory(categoryId) { (items, error) in
            XCTAssertNotNil(items)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testItemWithId() {
        let expectation = self.expectation(description: "tests retrieving an item by id")
        
        MixerClient.sharedClient.shop.getItemWithId(itemId) { (item, error) in
            XCTAssertNotNil(item)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
