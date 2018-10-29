//
//  MixerGroup.swift
//  Mixer API
//
//  Created by Jack Cook on 4/25/15.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//

// import UIKit

/// The group/role held by a given user.
public enum MixerGroup: String {
    case founder = "Founder"
    case staff = "Staff"
    case globalMod = "GlobalMod"
    case owner = "Owner"
    case moderator = "Mod"
    case pro = "Pro"
    case user = "User"
    
    public func getValue() -> Int {
        switch self {
        case .founder:
            return 6
        case .staff:
            return 5
        case .globalMod:
            return 4
        case .owner:
            return 3
        case .moderator:
            return 2
        case .pro:
            return 1
        case .user:
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
/*
public func chatColorForGroups(_ groups: [MixerGroup]) -> UIColor {
    if groups.contains(.owner) {
        return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    if groups.contains(.founder) {
        return UIColor(red: 181/255, green: 37/255, blue: 53/255, alpha: 1)
    }
    
    if groups.contains(.staff) {
        return UIColor(red: 236/255, green: 191/255, blue: 55/255, alpha: 1)
    }
    
    if groups.contains(.globalMod) {
        return UIColor(red: 7/255, green: 253/255, blue: 198/255, alpha: 1)
    }
    
    if groups.contains(.moderator) {
        return UIColor(red: 55/255, green: 237/255, blue: 59/255, alpha: 1)
    }
    
    if groups.contains(.pro) {
        return UIColor(red: 198/255, green: 66/255, blue: 234/255, alpha: 1)
    }
    
    return UIColor(red: 55/255, green: 170/255, blue: 213/255, alpha: 1)
}*/

/**
 Returns the highest group held by a user.
 
 :param: groups The user's held groups.
 :returns: The highest group held by the user.
 */
public func getHighestGroup(_ groups: [MixerGroup]) -> MixerGroup {
    var highestGroup = MixerGroup.user
    for group in groups {
        if group.getValue() > highestGroup.getValue() {
            highestGroup = group
        }
    }
    
    return highestGroup
}
