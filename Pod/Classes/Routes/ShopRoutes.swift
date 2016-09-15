//
//  ShopRoutes.swift
//  Beam
//
//  Created by Jack Cook on 1/9/16.
//  Copyright © 2016 MCProHosting. All rights reserved.
//

/// Routes that can be used to interact with and retrieve shop data.
public class ShopRoutes {
    
    // MARK: Retrieving Shop Data
    
    /**
     Retrieves all shop categories.
    
     :param: completion An optional completion block with retrieved shop categories.
     */
    public func getCategories(_ completion: ((_ categories: [BeamShopCategory]?, _ error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/shop/categories") { (json, error) in
            guard let categories = json?.array else {
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
    
    /**
     Retrieves a shop item with a specific identifier.
     
     :param: itemId The identifier of the item being requested.
     :param: completion An optional completion block with the retrieved item's data.
     */
    public func getItemWithId(_ itemId: Int, completion: ((_ item: BeamShopItem?, _ error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/shop/items/\(itemId)") { (json, error) in
            guard let json = json else {
                completion?(item: nil, error: error)
                return
            }
            
            let item = BeamShopItem(json: json)
            completion?(item: item, error: error)
        }
    }
    
    /**
     Retrieves shop items in a specific category.
     
     :param: categoryId The identifier of the category with items that are being requested.
     :param: completion An optional completion block with the requested items' data.
     */
    public func getItemsByCategory(_ categoryId: Int, completion: ((_ items: [BeamShopItem]?, _ error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/shop/categories/\(categoryId)/items") { (json, error) in
            guard let items = json?.array else {
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
