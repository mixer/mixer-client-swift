//
//  TypesRoutes.swift
//  Pods
//
//  Created by Jack Cook on 7/15/16.
//
//

/// Routes that can be used to interact with and retrieve type data.
public class TypesRoutes {
    
    // MARK: Retrieving Types
    
    /**
     Retrieves a type with the specified identifier.
     
     :param: id The identifier of the type being retrieved.
     :param: completion An optional completion block with retrieved channel data.
     */
    public func getTypeWithId(_ id: Int, completion: ((_ type: BeamType?, _ error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/types?where=id.eq.\(id)") { (json, error) in
            guard let json = json?[0] else {
                completion?(nil, error)
                return
            }
            
            let type = BeamType(json: json)
            completion?(type, error)
        }
    }
    
    /**
     Retrieves games that are being played by at least one channel.
     
     :param: completion An optional completion block with the retrieved channels' data.
     */
    public func getTypes(_ completion: ((_ types: [BeamType]?, _ error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/types", requestType: "GET", params: ["where": "online.neq.0"]) { (json, error) in
            guard let types = json?.array else {
                completion?(nil, error)
                return
            }
            
            var retrievedTypes = [BeamType]()
            
            for type in types {
                let retrievedType = BeamType(json: type)
                retrievedTypes.append(retrievedType)
            }
            
            completion?(retrievedTypes, error)
        }
    }
    
    /**
     Searches for types with a specified query.
     
     :param: query The query being used to search for types.
     :param: completion An optional completion block with the retrieved types' data.
     */
    public func getTypesByQuery(_ query: String, completion: ((_ types: [BeamType]?, _ error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/types", requestType: "GET", params: ["query": query]) { (json, error) in
            guard let types = json?.array else {
                completion?(nil, error)
                return
            }
            
            var retrievedTypes = [BeamType]()
            
            for type in types {
                let retrievedType = BeamType(json: type)
                retrievedTypes.append(retrievedType)
            }
            
            completion?(retrievedTypes, error)
        }
    }
}
