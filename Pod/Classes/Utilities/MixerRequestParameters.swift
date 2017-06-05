//
//  MixerRequestParameters.swift
//  Pods
//
//  Created by Jack Cook on 16/12/2016.
//
//

/// Parameters that can be passed to MixerRequest.dataRequest
struct MixerRequestParameters {
    
    /// The URL of the data being retrieved
    var baseURL: String
    
    /// The type of request being made
    var requestType: String
    
    /// The HTTP headers to be used in the request
    var headers: [String: String]
    
    /// The URL parameters to be used in the request
    var params: [String: String]
    
    /// The request body
    var body: AnyObject?
    
    /// Any special operations that should be performed for this request
    var options: MixerRequestOptions
    
    /// An optional completion block with retrieved data
    var completion: ((_ data: Data?, _ error: MixerRequestError?) -> Void)?
}
