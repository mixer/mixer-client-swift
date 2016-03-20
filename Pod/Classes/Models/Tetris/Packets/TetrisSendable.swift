//
//  TetrisSendable.swift
//  Pods
//
//  Created by Jack Cook on 3/5/16.
//
//

/// The protocol inherited by tetris packets that are being sent.
public protocol TetrisSendable {
    
    /// The packet's data.
    func data() -> [String: AnyObject]
    
    /// The packet's identifier.
    var identifier: String { get }
}
