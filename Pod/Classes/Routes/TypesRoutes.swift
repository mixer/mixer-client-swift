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
    public func getTypeWithId(id: Int, completion: ((type: BeamType?, error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/types?where=id.eq.\(id)") { (json, error) in
            guard let json = json?[0] else {
                completion?(type: nil, error: error)
                return
            }
            
            let type = BeamType(json: json)
            completion?(type: type, error: error)
        }
    }
    
    /**
     Retrieves games that are being played by at least one channel.
     
     :param: completion An optional completion block with the retrieved channels' data.
     */
    public func getTypes(completion: ((types: [BeamType]?, error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/types", requestType: "GET", params: ["where": "online.neq.0"]) { (json, error) in
            guard let types = json?.array else {
                completion?(types: nil, error: error)
                return
            }
            
            var retrievedTypes = [BeamType]()
            
            for type in types {
                let retrievedType = BeamType(json: type)
                retrievedTypes.append(retrievedType)
            }
            
            completion?(types: retrievedTypes, error: error)
        }
    }
    
    /**
     Searches for types with a specified query.
     
     :param: query The query being used to search for types.
     :param: completion An optional completion block with the retrieved types' data.
     */
    public func getTypesByQuery(query: String, completion: ((types: [BeamType]?, error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/types", requestType: "GET", params: ["query": query]) { (json, error) in
            guard let types = json?.array else {
                completion?(types: nil, error: error)
                return
            }
            
            var retrievedTypes = [BeamType]()
            
            for type in types {
                let retrievedType = BeamType(json: type)
                retrievedTypes.append(retrievedType)
            }
            
            completion?(types: retrievedTypes, error: error)
        }
    }
}
