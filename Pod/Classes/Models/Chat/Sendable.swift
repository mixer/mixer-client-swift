//
//  Sendable.swift
//  Beam API
//
//  Created by Jack Cook on 5/26/15.
//  Copyright (c) 2015 MCProHosting. All rights reserved.
//

public protocol Sendable {
    func arguments() -> [AnyObject]
    var identifier: String { get }
}
