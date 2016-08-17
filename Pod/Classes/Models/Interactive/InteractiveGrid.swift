//
//  InteractiveGrid.swift
//  Pods
//
//  Created by Jack Cook on 2/27/16.
//
//

/// The size of the control grid being used.
public enum InteractiveGrid {
    case Small
    case Medium
    case Large
    case Unknown
    
    /// Used to initialize an interactive grid value from its string counterpart.
    init(value: String?) {
        if let value = value {
            if value == "small" {
                self = .Small
            } else if value == "medium" {
                self = .Medium
            } else if value == "large" {
                self = .Large
            } else {
                self = .Unknown
            }
        } else {
            self = .Unknown
        }
    }
}
