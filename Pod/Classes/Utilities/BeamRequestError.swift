//
//  BeamRequestError.swift
//  Beam API
//
//  Created by Jack Cook on 8/4/15.
//  Copyright © 2015 MCProHosting. All rights reserved.
//

/// The type of a request error encountered by the app.
public enum BeamRequestError: ErrorType {
    
    // HTTP Errors
    case BadRequest,
    AccessDenied,
    NotFound
    
    // Beam Errors
    case NotAuthenticated,
    Offline,
    Unknown
    
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
