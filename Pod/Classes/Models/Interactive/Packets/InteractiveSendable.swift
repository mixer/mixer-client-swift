//
//  InteractiveSendable.swift
//  Pods
//
//  Created by Jack Cook on 3/5/16.
//
//

/// The protocol inherited by Interactive packets that are being sent.
public protocol InteractiveSendable {
    
    /// The packet's data.
    func data() -> [String: AnyObject]
    
    /// The packet's identifier.
    var identifier: String { get }
}
