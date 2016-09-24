//
//  TeamsRoutes.swift
//  Pods
//
//  Created by Jack Cook on 7/13/16.
//
//

/// Routes that can be used to interact with and retrieve stream team data.
public class TeamsRoutes {
    
    // MARK: Retrieving Stream Teams
    
    /**
     Retrieves a team with the specified identifier.
     
     :param: id The identifier of the team being retrieved.
     :param: completion An optional completion block with retrieved team data.
     */
    public func getTeamWithId(_ id: Int, completion: ((_ team: BeamTeam?, _ error: BeamRequestError?) -> Void)?) {
        getTeamWithEndpoint("/teams/\(id)", completion: completion)
    }
    
    /**
     Retrieves a team with the specified token.
     
     :param: token The token of the team being retrieved.
     :param: completion An optional completion block with retrieved team data.
     */
    public func getTeamWithToken(_ token: String, completion: ((_ team: BeamTeam?, _ error: BeamRequestError?) -> Void)?) {
        getTeamWithEndpoint("/teams/\(token)", completion: completion)
    }
    
    /**
     Retrieves a team from the specified endpoint.
     
     :param: endpoint The endpoint that the team is being retrieved from.
     :param: completion An optional completion block with retrieved team data.
     */
    fileprivate func getTeamWithEndpoint(_ endpoint: String, completion: ((_ team: BeamTeam?, _ error: BeamRequestError?) -> Void)?) {
        BeamRequest.request(endpoint) { (json, error) in
            guard let json = json else {
                completion?(nil, error)
                return
            }
            
            let team = BeamTeam(json: json)
            completion?(team, error)
        }
    }
    
    /**
     Retrieves paginated stream teams, sorted by descending viewer count.
     
     :param: page The page of stream teams to be requested.
     :param: completion An optional completion block with the retrieved teams' data.
     */
    public func getTeams(_ page: Int = 0, completion: ((_ teams: [BeamTeam]?, _ error: BeamRequestError?) -> Void)?) {
        let params = ["order": "totalViewersCurrent:desc"]
        
        BeamRequest.request("/teams", params: params) { (json, error) in
            guard let teams = json?.array else {
                completion?(nil, error)
                return
            }
            
            var retrievedTeams = [BeamTeam]()
            
            for team in teams {
                let retrievedTeam = BeamTeam(json: team)
                retrievedTeams.append(retrievedTeam)
            }
            
            completion?(retrievedTeams, error)
        }
    }
    
    // MARK: Retrieving Team Data
    
    /**
     Retrieves the users on a given stream team.
     
     :param: id The id of the team whose users are being requested.
     :param: completion An optional completion block with the retrieved users' data.
     */
    public func getMembersOfTeam(_ id: Int, completion: ((_ users: [BeamUser]?, _ error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/teams/\(id)/users") { (json, error) in
            guard let users = json?.array else {
                completion?(nil, error)
                return
            }
            
            var retrievedUsers = [BeamUser]()
            
            for user in users {
                let retrievedUser = BeamUser(json: user)
                retrievedUsers.append(retrievedUser)
            }
            
            completion?(retrievedUsers, error)
        }
    }
}
