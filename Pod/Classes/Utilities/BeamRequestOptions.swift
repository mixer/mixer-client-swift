//
//  BeamRequestOptions.swift
//  Pods
//
//  Created by Jack Cook on 06/12/2016.
//
//

public struct BeamRequestOptions: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    // Only use cookie-based authentication
    static let cookieAuth = BeamRequestOptions(rawValue: 1 << 0)
    
    // Don't pass any forms of authentication
    static let noAuth = BeamRequestOptions(rawValue: 1 << 1)
    
    // Store any received cookies
    static let storeCookies = BeamRequestOptions(rawValue: 1 << 2)
    
    // Store any received JWT tokens
    static let storeJWT = BeamRequestOptions(rawValue: 1 << 3)
}
