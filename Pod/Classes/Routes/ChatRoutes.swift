//
//  ChatRoutes.swift
//  Beam
//
//  Created by Jack Cook on 1/8/16.
//  Copyright © 2016 MCProHosting. All rights reserved.
//

/// Routes that can be used to interact with and retrieve chat data.
public class ChatRoutes {
    
    // MARK: Acting on Chat
    
    /**
     Deletes all chat messages from a channel.
    
     :param: channelId The identifier of the channel with messages that are being deleted.
     :param: completion An optional completion block that fires when the deletion has been completed.
     */
    public func deleteAllChatMessages(channelId: Int, completion: ((success: Bool, error: BeamRequestError?) -> Void)?) {
        self.deleteMessagesByEndpoint("/chats/\(channelId)/message", completion: completion)
    }
    
    /**
     Deletes a specific chat message from a channel.
     
     :param: channelId The identifier of the channel with a message that is being deleted.
     :param: messageId The identifier of the message that is being deleted.
     :completion: An optional completion block that fires when the deletion has been completed.
     */
    public func deleteChatMessage(channelId: Int, messageId: String, completion: ((success: Bool, error: BeamRequestError?) -> Void)?) {
        self.deleteMessagesByEndpoint("/chats/\(channelId)/message/\(messageId)", completion: completion)
    }
    
    /**
     Deletes messages using a specified endpoint.
     
     :param: endpoint The endpoint being used to delete chat messages.
     :completion: An optional completion block that fires when the deletion has been completed.
     */
    private func deleteMessagesByEndpoint(endpoint: String, completion: ((success: Bool, error: BeamRequestError?) -> Void)?) {
        BeamRequest.request(endpoint, requestType: "DELETE") { (json, error) -> Void in
            guard let _ = json else {
                completion?(success: false, error: error)
                return
            }
            
            completion?(success: error == nil, error: error)
        }
    }
    
    // MARK: Retrieving Chat Data
    
    /**
     Retrieves details used to connect to a channel's chat.
    
     :param: channelId The id of the channel being connected to.
     :param: completion An optional completion block with retrieved chat details.
     */
    public func getChatDetailsById(channelId: Int, completion: ((endpoints: [String]?, authKey: String?, error: BeamRequestError?) -> Void)?) {
        // TODO: Create a helper class to store all details retrieved with this method
        
        BeamRequest.request("/chats/\(channelId)", requestType: "GET") { (json, error) -> Void in
            guard let json = json else {
                completion?(endpoints: nil, authKey: nil, error: error)
                return
            }
            
            var retrievedEndpoints: [String]?
            var retrievedAuthKey: String?
            
            if let endpoints = json["endpoints"].array {
                retrievedEndpoints = [String]()
                for endpoint in endpoints {
                    retrievedEndpoints!.append(endpoint.stringValue)
                }
            }
            
            if let authKey = json["authkey"].string {
                retrievedAuthKey = authKey
            }
            
            completion?(endpoints: retrievedEndpoints, authKey: retrievedAuthKey, error: error)
        }
    }
    
    /**
     Retrieves a list of users viewing a specific channel.
     
     :param: channelId The identifier of the channel with viewers that are being retrieved.
     :param: completion An optional completion block with retrieved viewer data.
     */
    public func getViewersByChannel(channelId: Int, completion: ((viewers: [ChannelViewer]?, error: BeamRequestError?) -> Void)?) {
        self.getViewersByEndpoint("/chats/\(channelId)/users", params: [String: String](), completion: completion)
    }
    
    /**
     Retrieves channel viewers matching a specific query/search.
     
     :param: channelId The identifier of the channel with viewers that are being retrieved.
     :param: query The query that is being performed to search for viewers.
     :param: completion An optional completion block with retrieved viewer data.
     */
    public func getViewersByChannelWithQuery(channelId: Int, query: String, completion: ((viewers: [ChannelViewer]?, error: BeamRequestError?) -> Void)?) {
        self.getViewersByEndpoint("/chats/\(channelId)/users/search", params: ["username": query], completion: completion)
    }
    
    /**
     Retrieves channel viewers from a specific endpoint.
     
     :param: endpoint The endpoint that is being used to retrieve channel viewers.
     :param: params The parameters of the query being performed.
     :param: completion An optional completion block with retrieved viewer data.
     */
    private func getViewersByEndpoint(endpoint: String, params: [String: String], completion: ((viewers: [ChannelViewer]?, error: BeamRequestError?) -> Void)?) {
        BeamRequest.request(endpoint, requestType: "GET", params: params) { (json, error) -> Void in
            guard let json = json,
                let users = json.array else {
                    completion?(viewers: nil, error: error)
                    return
            }
            
            var retrievedUsers = [ChannelViewer]()
            
            for user in users {
                if let username = user["userName"].string,
                    let roles = user["userRoles"].array,
                    let userId = user["userId"].int {
                        var retrievedRoles = [BeamGroup]()
                        
                        for role in roles {
                            if let role = role.string {
                                if let retrievedRole = BeamGroup(rawValue: role) {
                                    retrievedRoles.append(retrievedRole)
                                } else {
                                    retrievedRoles.append(BeamGroup.User)
                                }
                            }
                        }
                        
                        let retrievedUser = ChannelViewer(username: username, roles: retrievedRoles, userId: userId)
                        retrievedUsers.append(retrievedUser)
                }
            }
            
            completion?(viewers: retrievedUsers, error: error)
        }
    }
    
    // MARK: Retrieving Emoticons
    
    /**
     Retrieves an emoticon image using a chat message component.
    
     :param: component The message component being used to retrieve the emoticon.
     :param: completion An optional completion block with the retrieved emoticon.
     */
    public func getEmoticon(component: BeamMessageComponent, completion: ((emoticon: UIImage?, error: BeamRequestError?) -> Void)?) {
        guard let source = component.source,
            pack = component.pack,
            coordinates = component.coordinates else {
                completion?(emoticon: nil, error: .Unknown)
                return
        }
        
        var imageUrl = ""
        
        if source == "builtin" {
            imageUrl = "https://beam.pro/_latest/emoticons/\(pack).png"
        } else if source == "external" {
            imageUrl = pack
        } else {
            print("unknown emoticon pack source: \(source)")
            completion?(emoticon: nil, error: .Unknown)
            return
        }
        
        BeamRequest.imageRequest(imageUrl) { (image, error) -> Void in
            guard let image = image else {
                completion?(emoticon: nil, error: error)
                return
            }
            
            let frame = CGRectMake(coordinates.x, coordinates.y, 24, 24)
            if let cropped = CGImageCreateWithImageInRect(image.CGImage, frame) {
                let emoticon = UIImage(CGImage: cropped)
                completion?(emoticon: emoticon, error: nil)
            } else {
                completion?(emoticon: nil, error: .Unknown)
            }
        }
    }
    
    /**
     Retrieves a spacesuit image given a specific user identifier.
     
     :param: userId The identifier of the user being placed in a spacesuit.
     :param: completion An optional completion block with the retrieved spacesuit.
     */
    public func getSpaceSuit(userId: Int, completion: ((spacesuit: UIImage?, error: BeamRequestError?) -> Void)?) {
        let imageUrl = "https://images.beam.pro/64x64/https://uploads.beam.pro/avatar/\(userId).jpg"
        
        BeamRequest.imageRequest(imageUrl) { (image, error) -> Void in
            let fullsuit = self.getSpaceSuitWithAvatar(image)
            completion?(spacesuit: fullsuit, error: nil)
        }
    }
    
    /**
     Creates a spacesuit given a user's avatar image.
     
     :param: avatar An image of the user's avatar.
     :returns: The avatar placed inside a spacesuit.
     */
    private func getSpaceSuitWithAvatar(avatar: UIImage?) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(20, 20), false, 0)
        avatar?.drawInRect(CGRectMake(3, 4, 14, 14))
        UIImage(named: "Space Suit")?.drawInRect(CGRectMake(0, 0, 20, 20))
        let fullsuit = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return fullsuit
    }
}

/// A viewer of a channel.
public struct ChannelViewer {
    
    /// The viewer's username.
    public var username: String
    
    /// The roles held by the viewer.
    public var roles: [BeamGroup]
    
    /// The identifier of the viewer.
    public var userId: Int
}
