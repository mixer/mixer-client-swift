//
//  TetrisSendable.swift
//  Pods
//
//  Created by Jack Cook on 3/5/16.
//
//

public protocol TetrisSendable {
    func data() -> [String: AnyObject]
    var identifier: String { get }
}
