//
//  BeamGroup.swift
//  Beam API
//
//  Created by Jack Cook on 4/25/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import UIKit

/// The group/role held by a given user.
public enum BeamGroup: String {
    case Founder = "Founder"
    case Staff = "Staff"
    case GlobalMod = "GlobalMod"
    case Owner = "Owner"
    case Moderator = "Mod"
    case Pro = "Pro"
    case User = "User"
    
    public func getValue() -> Int {
        switch self {
        case .Founder:
            return 6
        case .Staff:
            return 5
        case .GlobalMod:
            return 4
        case .Owner:
            return 3
        case .Moderator:
            return 2
        case .Pro:
            return 1
        case .User:
            return 0
        }
    }
}

// TODO: Find somewhere to move these functions

/**
 Returns a color that should be given to a user in chat given their groups.

 :param: groups The user's held groups.
 :returns: The color that should be given to the user.
 */
public func chatColorForGroups(groups: [BeamGroup]) -> UIColor {
    if groups.contains(.Owner) {
        return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    if groups.contains(.Founder) {
        return UIColor(red: 181/255, green: 37/255, blue: 53/255, alpha: 1)
    }
    
    if groups.contains(.Staff) {
        return UIColor(red: 236/255, green: 191/255, blue: 55/255, alpha: 1)
    }
    
    if groups.contains(.GlobalMod) {
        return UIColor(red: 7/255, green: 253/255, blue: 198/255, alpha: 1)
    }
    
    if groups.contains(.Moderator) {
        return UIColor(red: 55/255, green: 237/255, blue: 59/255, alpha: 1)
    }
    
    if groups.contains(.Pro) {
        return UIColor(red: 198/255, green: 66/255, blue: 234/255, alpha: 1)
    }
    
    return UIColor(red: 55/255, green: 170/255, blue: 213/255, alpha: 1)
}

/**
 Returns the highest group held by a user.
 
 :param: groups The user's held groups.
 :returns: The highest group held by the user.
 */
public func getHighestGroup(groups: [BeamGroup]) -> BeamGroup {
    var highestGroup = BeamGroup.User
    for group in groups {
        if group.getValue() > highestGroup.getValue() {
            highestGroup = group
        }
    }
    
    return highestGroup
}
