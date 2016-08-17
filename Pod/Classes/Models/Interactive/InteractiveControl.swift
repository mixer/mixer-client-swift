//
//  InteractiveControl.swift
//  Pods
//
//  Created by Jack Cook on 2/27/16.
//
//

import SwiftyJSON

/// A base Interactive control object.
public class InteractiveControl {
    
    /// The control's blueprint, containing valid configurations.
    public let blueprint: InteractiveBlueprint?
    
    /// The control's identifier.
    public let id: Int
    
    /**
     Used to initialize an interactive control.
     
     :param: id The control's identifier.
     :param: blueprint The control's blueprint, containing valid configurations.
     */
    public init(id: Int, blueprint: InteractiveBlueprint?) {
        self.id = id
        self.blueprint = blueprint
    }
}
