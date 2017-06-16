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
        case twitter = "twitter", discord = "discord"
    }
    
    // MARK: Creating OAuth Flows
    
    /**
     Retrieves the authorization URL for a given OAuth provider.
     
     :param: provider The provider to be used for authentication.
     :returns: The URL used to begin the OAuth flow, to be opened in a web browser.
     */
    public func getAuthorizationURL(_ provider: OAuthProvider) -> URL {
        return URL(string: "https://mixer.com/api/v1/oauth/\(provider.rawValue)/check")!
    }
    
    /**
     Logs in given a cookie returned from the Mixer backend.
     
     :param: provider The provider to be used for authentication.
     :param: cookie The full cookie string.
     */
    public func loginWithProvider(_ provider: OAuthProvider, cookie: String, completion: ((_ user: MixerUser?, _ error: MixerRequestError?) -> Void)?) {
        let headers = ["Cookie": cookie]
        
        MixerRequest.request("/oauth/\(provider.rawValue)/login", requestType: "POST", headers: headers, options: [.noAuth, .storeCookies]) { (json, error) in
            guard let json = json , error == nil else {
                completion?(nil, error)
                return
            }
            
            let user = MixerUser(json: json)
            MixerUserDefaults.standard.set(user.encoded, forKey: "UserData")
            
            NotificationCenter.default.post(name: MixerAuthenticatedNotification, object: nil)
            
            completion?(user, error)
        }
    }
}
