//
//  JWTRoutes.swift
//  Pods
//
//  Created by Jack Cook on 06/12/2016.
//
//

/// Routes that can be used to interact with and retrieve JWT data.
public class JWTRoutes {
    
    // MARK: Getting Tokens
    
    /**
     Generates a JWT grant.
     
     :param: completion An optional completion block with retrieved JWT data.
     */
    public func generateJWTGrant(_ completion: ((_ error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/jwt/authorize", requestType: "POST") { (json, error) in
            completion?(error)
        }
    }
}
