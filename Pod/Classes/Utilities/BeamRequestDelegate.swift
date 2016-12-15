//
//  BeamRequestDelegate.swift
//  Pods
//
//  Created by Jack Cook on 14/12/2016.
//
//

/// A delegate that allows clients to provide details to the BeamRequest class.
public protocol BeamRequestDelegate: class {
    
    /// Provides the API client with a new JWT token to use in the event that one is needed.
    func requestNewJWT(completion: (_ error: BeamRequestError?) -> Void)
}
