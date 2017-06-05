//
//  ChatSendable.swift
//  Mixer API
//
//  Created by Jack Cook on 5/26/15.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//

/// The protocol inherited by packets that are being sent.
public protocol ChatSendable {
    
    /// The packet's arguments.
    func arguments() -> [AnyObject]
    
    /// The packet's identifier.
    var identifier: String { get }
}
