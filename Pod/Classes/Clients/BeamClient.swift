//
//  BeamClient.swift
//  Beam API
//
//  Created by Jack Cook on 3/15/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

public class BeamClient {
    
    public class var sharedClient: BeamClient {
        struct Static {
            static let instance = BeamClient()
        }
        return Static.instance
    }
    
    public var achievements: AchievementsRoutes!
    public var channels: ChannelsRoutes!
    public var chat: ChatRoutes!
    public var shop: ShopRoutes!
    public var tetris: TetrisRoutes!
    public var users: UsersRoutes!
    
    public init() {
        achievements = AchievementsRoutes()
        channels = ChannelsRoutes()
        chat = ChatRoutes()
        shop = ShopRoutes()
        tetris = TetrisRoutes()
        users = UsersRoutes()
    }
}
