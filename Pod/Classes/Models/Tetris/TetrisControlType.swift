//
//  TetrisControlType.swift
//  Pods
//
//  Created by Jack Cook on 2/27/16.
//
//

public enum TetrisControlType: String {
    case Button
    case Unknown
    
    public init(value: String?) {
        if let value = value {
            if value == "tactiles" {
                self = .Button
            } else {
                self = .Unknown
            }
        } else {
            self = .Unknown
        }
    }
}
