//
//  AchievementsRoutes.swift
//  Beam
//
//  Created by Jack Cook on 1/9/16.
//  Copyright © 2016 MCProHosting. All rights reserved.
//

/// Routes that can be used to interact with and retrieve achievement data.
public class AchievementsRoutes {
    
    // MARK: Retrieving Achievements
    
    /**
     Retrieves all achievements.
    
     :param: completion An optional completion block with retrieved achievement data.
     */
    public func getAchievements(completion: ((achievements: [BeamAchievement]?, error: BeamRequestError?) -> Void)?) {
        self.getAchievementsByEndpoint("/achievements", completion: completion)
    }
    
    /**
     Retrieves all achievements that have been earned by a user.
     
     :param: userId The id of the user whose achievements are being retrieved.
     :param: completion An optional completion block with retrieved achievement data.
     */
    public func getAchievementsByUser(userId: Int, completion: ((achievements: [BeamAchievement]?, error: BeamRequestError?) -> Void)?) {
        self.getAchievementsByEndpoint("/users/\(userId)/achievements", completion: completion)
    }
    
    /**
     Retrieves all achievements that are returned by a given endpoint.
     
     :param: endpoint The endpoint that achievements are being retrieved from.
     :param: completion An optional completion block with retrieved achievement data.
     */
    private func getAchievementsByEndpoint(endpoint: String, completion: ((achievements: [BeamAchievement]?, error: BeamRequestError?) -> Void)?) {
        BeamRequest.request(endpoint, requestType: "GET") { (json, error) -> Void in
            guard let json = json,
                let achievements = json.array else {
                    completion?(achievements: nil, error: error)
                    return
            }
            
            var retrievedAchievements = [BeamAchievement]()
            
            for achievement in achievements {
                let retrievedAchievement = BeamAchievement(json: achievement)
                retrievedAchievements.append(retrievedAchievement)
            }
            
            completion?(achievements: retrievedAchievements, error: error)
        }
    }
}
