//
//  InteractiveRoutes.swift
//  Pods
//
//  Created by Jack Cook on 2/27/16.
//
//

/// Routes that can be used to interact with and receive Interactive data.
public class InteractiveRoutes {
    
    // MARK: Retrieving Interactive Data
    
    /**
     Retrieves details used to connect to a channel's Interactive socket.
    
     :param: channelId The id of the channel being connected to.
     :param: completion An optional completion block with retrieved Interactive details.
     */
    public func getInteractiveDataByChannel(channelId: Int, completion: ((data: InteractiveData?, error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/interactive/\(channelId)") { (json, error) in
            guard let json = json else {
                completion?(data: nil, error: error)
                return
            }
            
            let data = InteractiveData(json: json)
            completion?(data: data, error: error)
        }
    }
}
