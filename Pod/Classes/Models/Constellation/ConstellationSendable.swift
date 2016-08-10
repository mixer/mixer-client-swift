//
//  ConstellationSendable.swift
//  Pods
//
//  Created by Jack Cook on 8/10/16.
//
//

/// The protocol inherited by constellation packets that can be sent.
public protocol ConstellationSendable {
    
    /// The packet's method.
    var method: String { get }
    
    /// The packet's parameters.
    var params: [String: AnyObject] { get }
}
