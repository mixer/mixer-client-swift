//
//  TetrisGrid.swift
//  Pods
//
//  Created by Jack Cook on 2/27/16.
//
//

public enum TetrisGrid {
    case Small
    case Medium
    case Large
    case Unknown
    
    public init(value: String?) {
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
