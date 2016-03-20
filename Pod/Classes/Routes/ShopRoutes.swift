//
//  ShopRoutes.swift
//  Beam
//
//  Created by Jack Cook on 1/9/16.
//  Copyright © 2016 MCProHosting. All rights reserved.
//

public class ShopRoutes {
    
    // MARK: Retrieving Shop Data
    
    public func getCategories(completion: ((categories: [BeamShopCategory]?, error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/shop/categories", requestType: "GET") { (json, error) -> Void in
            guard let json = json,
                categories = json.array else {
                    completion?(categories: nil, error: error)
                    return
            }
            
            var retrievedCategories = [BeamShopCategory]()
            
            for category in categories {
                let retrievedCategory = BeamShopCategory(json: category)
                retrievedCategories.append(retrievedCategory)
            }
            
            completion?(categories: retrievedCategories, error: error)
        }
    }
    
    public func getItemWithId(itemId: Int, completion: ((item: BeamShopItem?, error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/shop/items/\(itemId)", requestType: "GET") { (json, error) -> Void in
            guard let json = json else {
                completion?(item: nil, error: error)
                return
            }
            
            let item = BeamShopItem(json: json)
            completion?(item: item, error: error)
        }
    }
    
    public func getItemsByCategory(categoryId: Int, completion: ((items: [BeamShopItem]?, error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/shop/categories/\(categoryId)/items", requestType: "GET") { (json, error) -> Void in
            guard let json = json,
                items = json.array else {
                    completion?(items: nil, error: error)
                    return
            }
            
            var retrievedItems = [BeamShopItem]()
            
            for item in items {
                let retrievedItem = BeamShopItem(json: item)
                retrievedItems.append(retrievedItem)
            }
            
            completion?(items: retrievedItems, error: error)
        }
    }
}
