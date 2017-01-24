//
//  BeamUserDefaults.swift
//  Pods
//
//  Created by Daniel Niemeyer on 1/23/17.
//

import Foundation

public class BeamUserDefaults: UserDefaults {
    
    /// MARK: Properties
    
    fileprivate static var userDefaults: UserDefaults?
    
    /// The client's shared instance.
    override static open var standard: UserDefaults {
        return userDefaults ?? super.standard
    }
    
    /// MARK: Methods
    
    /// Points the user defaults storage to the shared app container group.
    ///
    /// - Parameter suiteName: Application group shared key
    public static func set(suiteName: String) -> Bool {
        if let userDefaults = UserDefaults(suiteName: suiteName) {
            self.userDefaults = userDefaults
            return true
        }
        return false
    }
}
