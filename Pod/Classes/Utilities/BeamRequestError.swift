//
//  BeamRequestError.swift
//  Beam API
//
//  Created by Jack Cook on 8/4/15.
//  Copyright © 2015 MCProHosting. All rights reserved.
//

import SwiftyJSON

/// The type of a request error encountered by the app.
public enum BeamRequestError: Equatable, Error {
    
    // HTTP Errors
    case badRequest(data: JSON?),
    accessDenied,
    notFound
    
    // Beam Errors
    case notAuthenticated,
    offline,
    unknown(data: JSON?)
    
    // Login Errors
    case invalidCredentials,
    requires2FA
    
    // Registration Errors
    case invalidUsername,
    reservedUsername,
    takenUsername,
    weakPassword,
    invalidEmail,
    takenEmail
}

/// Workaround for the fact that enums with associated values can't have raw types.
public func ==(lhs: BeamRequestError, rhs: BeamRequestError) -> Bool {
    switch (lhs, rhs) {
    case (.badRequest(_), .badRequest(_)): return true
    case (.accessDenied, .accessDenied): return true
    case (.notFound, .notFound): return true
    case (.notAuthenticated, .notAuthenticated): return true
    case (.offline, .offline): return true
    case (.unknown(_), .unknown(_)): return true
    case (.invalidCredentials, .invalidCredentials): return true
    case (.requires2FA, .requires2FA): return true
    case (.invalidUsername, .invalidUsername): return true
    case (.reservedUsername, .reservedUsername): return true
    case (.takenUsername, .takenUsername): return true
    case (.weakPassword, .weakPassword): return true
    case (.invalidEmail, .invalidEmail): return true
    case (.takenEmail, .takenEmail): return true
    default: return false
    }
}
