//
//  IngestsRoutes.swift
//  Pods
//
//  Created by Jack Cook on 7/12/16.
//
//

/// Routes that can be used to retrieve ingest data.
public class IngestsRoutes {
    
    // MARK: Retrieving Ingests
    
    /**
     Retrieves all ingests.
     
     :param: completion An optional completion block with retrieved ingest data.
     */
    public func getIngests(completion: ((ingests: [BeamIngest]?, error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/ingests") { (json, error) in
            guard let json = json, ingests = json.array else {
                completion?(ingests: nil, error: error)
                return
            }
            
            var retrievedIngests = [BeamIngest]()
            
            for ingest in ingests {
                let retrievedIngest = BeamIngest(json: ingest)
                retrievedIngests.append(retrievedIngest)
            }
            
            completion?(ingests: retrievedIngests, error: error)
        }
    }
}
