//
//  OAuthRoutes.swift
//  Pods
//
//  Created by Jack Cook on 7/14/16.
//
//

/// Routes that can be used to create and interact with OAuth flows.
public class OAuthRoutes {
    
    /// The provider being used for authentication.
    public enum OAuthProvider: String {
        case Twitter = "twitter", Discord = "discord"
    }
    
    // MARK: Creating OAuth Flows
    
    /**
     Retrieves the authorization URL for a given OAuth provider.
     
     :param: provider The provider to be used for authentication.
     :returns: The URL used to begin the OAuth flow, to be opened in a web browser.
     */
    public func getAuthorizationURL(_ provider: OAuthProvider) -> URL {
        return URL(string: "https://beam.pro/api/v1/oauth/\(provider.rawValue)/check")!
    }
    
    /**
     Logs in given a cookie returned from the Beam backend.
     
     :param: provider The provider to be used for authentication.
     :param: cookie The full cookie string.
     */
    public func loginWithProvider(_ provider: OAuthProvider, cookie: String, completion: ((_ user: BeamUser?, _ error: BeamRequestError?) -> Void)?) {
        let headers = ["Cookie": cookie]
        
        BeamRequest.request("/oauth/\(provider.rawValue)/login", requestType: "POST", headers: headers) { (json, error) in
            guard let json = json , error == nil else {
                completion?(nil, error)
                return
            }
            
            let user = BeamUser(json: json)
            let session = BeamSession(user: user)
            BeamSession.sharedSession = session
            
            NotificationCenter.default.post(name: BeamAuthenticatedNotification, object: nil)
            
            completion?(user, error)
        }
    }
}
