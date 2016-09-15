//
//  InteractiveGrid.swift
//  Pods
//
//  Created by Jack Cook on 2/27/16.
//
//

/// The size of the control grid being used.
public enum InteractiveGrid {
    case small
    case medium
    case large
    case unknown
    
    /// Used to initialize an interactive grid value from its string counterpart.
    init(value: String?) {
        if let value = value {
            if value == "small" {
                self = .small
            } else if value == "medium" {
                self = .medium
            } else if value == "large" {
                self = .large
            } else {
                self = .unknown
            }
        } else {
            self = .unknown
        }
    }
}
