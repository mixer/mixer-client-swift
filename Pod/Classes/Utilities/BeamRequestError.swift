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
    ReservedUsername,
    TakenUsername,
    WeakPassword,
    InvalidEmail,
    TakenEmail
}

/// Workaround for the fact that enums with associated values can't have raw types.
public func ==(lhs: BeamRequestError, rhs: BeamRequestError) -> Bool {
    switch (lhs, rhs) {
    case (.BadRequest(_), .BadRequest(_)): return true
    case (.AccessDenied, .AccessDenied): return true
    case (.NotFound, .NotFound): return true
    case (.NotAuthenticated, .NotAuthenticated): return true
    case (.Offline, .Offline): return true
    case (.Unknown(_), .Unknown(_)): return true
    case (.InvalidCredentials, .InvalidCredentials): return true
    case (.Requires2FA, .Requires2FA): return true
    case (.InvalidUsername, .InvalidUsername): return true
    case (.ReservedUsername, .ReservedUsername): return true
    case (.TakenUsername, .TakenUsername): return true
    case (.WeakPassword, .WeakPassword): return true
    case (.InvalidEmail, .InvalidEmail): return true
    case (.TakenEmail, .TakenEmail): return true
    default: return false
    }
}
