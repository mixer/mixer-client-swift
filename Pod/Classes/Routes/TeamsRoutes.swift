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
    public func getTeamWithId(id: Int, completion: ((team: BeamTeam?, error: BeamRequestError?) -> Void)?) {
        getTeamWithEndpoint("/teams/\(id)", completion: completion)
    }
    
    /**
     Retrieves a team with the specified token.
     
     :param: token The token of the team being retrieved.
     :param: completion An optional completion block with retrieved team data.
     */
    public func getTeamWithToken(token: String, completion: ((team: BeamTeam?, error: BeamRequestError?) -> Void)?) {
        getTeamWithEndpoint("/teams/\(token)", completion: completion)
    }
    
    /**
     Retrieves a team from the specified endpoint.
     
     :param: endpoint The endpoint that the team is being retrieved from.
     :param: completion An optional completion block with retrieved team data.
     */
    private func getTeamWithEndpoint(endpoint: String, completion: ((team: BeamTeam?, error: BeamRequestError?) -> Void)?) {
        BeamRequest.request(endpoint) { (json, error) in
            guard let json = json else {
                completion?(team: nil, error: error)
                return
            }
            
            let team = BeamTeam(json: json)
            completion?(team: team, error: error)
        }
    }
    
    /**
     Retrieves paginated stream teams, sorted by descending viewer count.
     
     :param: page The page of stream teams to be requested.
     :param: completion An optional completion block with the retrieved teams' data.
     */
    public func getTeams(page: Int = 0, completion: ((teams: [BeamTeam]?, error: BeamRequestError?) -> Void)?) {
        var params = ["order": "totalViewersCurrent:desc"]
        
        BeamRequest.request("/teams", params: params) { (json, error) in
            guard let teams = json?.array else {
                completion?(teams: nil, error: error)
                return
            }
            
            var retrievedTeams = [BeamTeam]()
            
            for team in teams {
                let retrievedTeam = BeamTeam(json: team)
                retrievedTeams.append(retrievedTeam)
            }
            
            completion?(teams: retrievedTeams, error: error)
        }
    }
    
    // MARK: Retrieving Team Data
    
    /**
     Retrieves the users on a given stream team.
     
     :param: id The id of the team whose users are being requested.
     :param: completion An optional completion block with the retrieved users' data.
     */
    public func getMembersOfTeam(id: Int, completion: ((users: [BeamUser]?, error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/teams/\(id)/users") { (json, error) in
            guard let users = json?.array else {
                completion?(users: nil, error: error)
                return
            }
            
            var retrievedUsers = [BeamUser]()
            
            for user in users {
                let retrievedUser = BeamUser(json: user)
                retrievedUsers.append(retrievedUser)
            }
            
            completion?(users: retrievedUsers, error: error)
        }
    }
}
