//
//  MixerRequestOptions.swift
//  Pods
//
//  Created by Jack Cook on 06/12/2016.
//
//

public struct MixerRequestOptions: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    // Only use cookie-based authentication
    public static let cookieAuth = MixerRequestOptions(rawValue: 1 << 0)
    
    // Don't pass any forms of authentication
    public static let noAuth = MixerRequestOptions(rawValue: 1 << 1)
    
    // Store any received cookies
    public static let storeCookies = MixerRequestOptions(rawValue: 1 << 2)
    
    // Store any received JWT tokens
    public static let storeJWT = MixerRequestOptions(rawValue: 1 << 3)
    
    // Request may need a CSRF token
    public static let mayNeedCSRF = MixerRequestOptions(rawValue: 1 << 4)
}
