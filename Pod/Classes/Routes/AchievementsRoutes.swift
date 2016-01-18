//
//  AchievementsRoutes.swift
//  Beam
//
//  Created by Jack Cook on 1/9/16.
//  Copyright © 2016 MCProHosting. All rights reserved.
//

public class AchievementsRoutes {
    
    // MARK: Retrieving Achievements
    
    public func getAchievements(completion: (achievements: [BeamAchievement]?, error: BeamRequestError?) -> Void) {
        self.getAchievementsByEndpoint("/achievements", completion: completion)
    }
    
    public func getAchievementsByUser(userId: Int, completion: (achievements: [BeamAchievement]?, error: BeamRequestError?) -> Void) {
        self.getAchievementsByEndpoint("/users/\(userId)/achievements", completion: completion)
    }
    
    private func getAchievementsByEndpoint(endpoint: String, completion: (achievements: [BeamAchievement]?, error: BeamRequestError?) -> Void) {
        BeamRequest.request(endpoint, requestType: "GET") { (json, error) -> Void in
            guard let json = json,
                let achievements = json.array else {
                    completion(achievements: nil, error: error)
                    return
            }
            
            var retrievedAchievements = [BeamAchievement]()
            
            for achievement in achievements {
                let retrievedAchievement = BeamAchievement(json: achievement)
                retrievedAchievements.append(retrievedAchievement)
            }
            
            completion(achievements: retrievedAchievements, error: error)
        }
    }
}
