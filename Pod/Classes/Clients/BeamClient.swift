//
//  BeamClient.swift
//  Beam API
//
//  Created by Jack Cook on 3/15/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

/// The main class of the API client.
public class BeamClient {
    
    /// The client's shared instance.
    public class var sharedClient: BeamClient {
        struct Static {
            static let instance = BeamClient()
        }
        return Static.instance
    }
    
    /// The property through which all achievement methods are accessed.
    public var achievements: AchievementsRoutes
    
    /// The property through which all channel methods are accessed.
    public var channels: ChannelsRoutes
    
    /// The property through which all chat methods are accessed.
    public var chat: ChatRoutes
    
    /// The property through which all shop methods are accessed.
    public var shop: ShopRoutes
    
    /// The property through which all tetris methods are accessed.
    public var tetris: TetrisRoutes
    
    /// The property through which all user methods are accessed.
    public var users: UsersRoutes
    
    /// The client's initializer. You will never have to call this yourself.
    private init() {
        achievements = AchievementsRoutes()
        channels = ChannelsRoutes()
        chat = ChatRoutes()
        shop = ShopRoutes()
        tetris = TetrisRoutes()
        users = UsersRoutes()
    }
}
