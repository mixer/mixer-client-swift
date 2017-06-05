//
//  AchievementsRoutes.swift
//  Mixer
//
//  Created by Jack Cook on 1/9/16.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//

/// Routes that can be used to interact with and retrieve achievement data.
public class AchievementsRoutes {
    
    // MARK: Retrieving Achievements
    
    /**
     Retrieves all achievements.
     
     :param: completion An optional completion block with retrieved achievement data.
     */
    public func getAchievements(_ completion: ((_ achievements: [MixerAchievement]?, _ error: MixerRequestError?) -> Void)?) {
        MixerRequest.request("/achievements") { (json, error) in
            guard let achievements = json?.array else {
                completion?(nil, error)
                return
            }
            
            var retrievedAchievements = [MixerAchievement]()
            
            for achievement in achievements {
                let retrievedAchievement = MixerAchievement(json: achievement)
                retrievedAchievements.append(retrievedAchievement)
            }
            
            completion?(retrievedAchievements, error)
        }
    }
}
