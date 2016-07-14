//
//  BeamRequestError.swift
//  Beam API
//
//  Created by Jack Cook on 8/4/15.
//  Copyright © 2015 MCProHosting. All rights reserved.
//

import SwiftyJSON

/// The type of a request error encountered by the app.
public enum BeamRequestError: Equatable, ErrorType {
    
    // HTTP Errors
    case BadRequest(data: JSON?),
    AccessDenied,
    NotFound
    
    // Beam Errors
    case NotAuthenticated,
    Offline,
    Unknown(data: JSON?)
    
    // Login Errors
    case InvalidCredentials,
    Requires2FA
    
    // Registration Errors
    case InvalidUsername,
    TakenUsername,
    WeakPassword,
    InvalidEmail,
    TakenEmail
}

/// Workaround for the fact that enums with associated values can't have raw types.
public func ==(lhs: BeamRequestError, rhs: BeamRequestError) -> Bool {
    switch (lhs, rhs) {
    case (let .BadRequest(_), let .BadRequest(_)): return true
    case (let .AccessDenied, let .AccessDenied): return true
    case (let .NotFound, let .NotFound): return true
    case (let .NotAuthenticated, let .NotAuthenticated): return true
    case (let .Offline, let .Offline): return true
    case (let .Unknown(_), let .Unknown(_)): return true
    case (let .InvalidCredentials, let .InvalidCredentials): return true
    case (let .Requires2FA, let .Requires2FA): return true
    case (let .InvalidUsername, let .InvalidUsername): return true
    case (let .TakenUsername, let .TakenUsername): return true
    case (let .WeakPassword, let .WeakPassword): return true
    case (let .InvalidEmail, let .InvalidEmail): return true
    case (let .TakenEmail, let .TakenEmail): return true
    default: return false
    }
}
