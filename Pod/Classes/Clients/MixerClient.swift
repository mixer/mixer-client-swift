//
//  MixerClient.swift
//  Mixer API
//
//  Created by Jack Cook on 3/15/15.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//

/// The main class of the API client.
public class MixerClient {
    
    /// The client's shared instance.
    public class var sharedClient: MixerClient {
        struct Static {
            static let instance = MixerClient()
        }
        return Static.instance
    }
    
    /// The property through which all achievement methods are accessed.
    public let achievements: AchievementsRoutes
    
    /// The property through which all channel methods are accessed.
    public let channels: ChannelsRoutes
    
    /// The property through which all chat methods are accessed.
    public let chat: ChatRoutes
    
    /// The property through which all ingest methods are accessed.
    public let ingests: IngestsRoutes
    
    /// The property through which all interactive methods are accessed.
    public let interactive: InteractiveRoutes
    
    /// The property through which all JWT methods are accessed.
    public let jwt: JWTRoutes
    
    /// The property through which all notification methods are accessed.
    public let notifications: NotificationsRoutes
    
    /// The property through which all OAuth methods are accessed.
    public let oauth: OAuthRoutes
    
    /// The property through which all recording methods are accessed.
    public let recordings: RecordingsRoutes
    
    /// The property through which all shop methods are accessed.
    public let shop: ShopRoutes
    
    /// The property through which all team methods are accessed.
    public let teams: TeamsRoutes
    
    /// The property through which all type methods are accessed.
    public let types: TypesRoutes
    
    /// The property through which all user methods are accessed.
    public let users: UsersRoutes
    
    /// The client's initializer. You will never have to call this yourself.
    fileprivate init() {
        achievements = AchievementsRoutes()
        channels = ChannelsRoutes()
        chat = ChatRoutes()
        ingests = IngestsRoutes()
        interactive = InteractiveRoutes()
        jwt = JWTRoutes()
        notifications = NotificationsRoutes()
        oauth = OAuthRoutes()
        recordings = RecordingsRoutes()
        shop = ShopRoutes()
        teams = TeamsRoutes()
        types = TypesRoutes()
        users = UsersRoutes()
    }
}
