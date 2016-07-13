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
        BeamRequest.request("/achievements", requestType: "GET") { (json, error) in
            guard let json = json, achievements = json.array else {
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
