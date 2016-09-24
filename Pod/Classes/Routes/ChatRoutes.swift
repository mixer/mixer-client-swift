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
    public func deleteAllChatMessages(_ channelId: Int, completion: ((_ error: BeamRequestError?) -> Void)?) {
        deleteMessagesByEndpoint("/chats/\(channelId)/message", completion: completion)
    }
    
    /**
     Deletes a specific chat message from a channel.
     
     :param: channelId The identifier of the channel with a message that is being deleted.
     :param: messageId The identifier of the message that is being deleted.
     :completion: An optional completion block that fires when the deletion has been completed.
     */
    public func deleteChatMessage(_ channelId: Int, messageId: String, completion: ((_ error: BeamRequestError?) -> Void)?) {
        deleteMessagesByEndpoint("/chats/\(channelId)/message/\(messageId)", completion: completion)
    }
    
    /**
     Deletes messages using a specified endpoint.
     
     :param: endpoint The endpoint being used to delete chat messages.
     :completion: An optional completion block that fires when the deletion has been completed.
     */
    fileprivate func deleteMessagesByEndpoint(_ endpoint: String, completion: ((_ error: BeamRequestError?) -> Void)?) {
        guard let _ = BeamSession.sharedSession else {
            completion?(.notAuthenticated)
            return
        }
        
        BeamRequest.request(endpoint, requestType: "DELETE") { (json, error) in
            completion?(error)
        }
    }
    
    // MARK: Retrieving Chat Data
    
    /**
     Retrieves details used to connect to a channel's chat.
    
     :param: channelId The id of the channel being connected to.
     :param: completion An optional completion block with retrieved chat details.
     */
    public func getChatDetailsById(_ channelId: Int, completion: ((_ endpoints: [String]?, _ authKey: String?, _ error: BeamRequestError?) -> Void)?) {
        // TODO: Create a helper class to store all details retrieved with this method
        
        BeamRequest.request("/chats/\(channelId)") { (json, error) in
            guard let json = json else {
                completion?(nil, nil, error)
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
            
            completion?(retrievedEndpoints, retrievedAuthKey, error)
        }
    }
    
    /**
     Retrieves a list of users viewing a specific channel.
     
     :param: channelId The identifier of the channel with viewers that are being retrieved.
     :param: completion An optional completion block with retrieved viewer data.
     */
    public func getViewersByChannel(_ channelId: Int, completion: ((_ viewers: [ChannelViewer]?, _ error: BeamRequestError?) -> Void)?) {
        getViewersByEndpoint("/chats/\(channelId)/users", params: [String: String](), completion: completion)
    }
    
    /**
     Retrieves channel viewers matching a specific query/search.
     
     :param: channelId The identifier of the channel with viewers that are being retrieved.
     :param: query The query that is being performed to search for viewers.
     :param: completion An optional completion block with retrieved viewer data.
     */
    public func getViewersByChannelWithQuery(_ channelId: Int, query: String, completion: ((_ viewers: [ChannelViewer]?, _ error: BeamRequestError?) -> Void)?) {
        getViewersByEndpoint("/chats/\(channelId)/users/search", params: ["username": query], completion: completion)
    }
    
    /**
     Retrieves channel viewers from a specific endpoint.
     
     :param: endpoint The endpoint that is being used to retrieve channel viewers.
     :param: params The parameters of the query being performed.
     :param: completion An optional completion block with retrieved viewer data.
     */
    fileprivate func getViewersByEndpoint(_ endpoint: String, params: [String: String], completion: ((_ viewers: [ChannelViewer]?, _ error: BeamRequestError?) -> Void)?) {
        BeamRequest.request(endpoint, requestType: "GET", params: params) { (json, error) in
            guard let users = json?.array else {
                completion?(nil, error)
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
            
            completion?(retrievedUsers, error)
        }
    }
    
    // MARK: Retrieving Emoticons
    
    /**
     Retrieves an emoticon image using a chat message component. Currently is missing a unit test.
    
     :param: component The message component being used to retrieve the emoticon.
     :returns: The emoticon image.
     */
    public func getEmoticon(_ component: BeamMessageComponent) -> UIImage? {
        guard let source = component.source, let pack = component.pack, let coordinates = component.coordinates else {
            return nil
        }
        
        var imageUrl = ""
        
        if source == "builtin" {
            imageUrl = "https://beam.pro/_latest/emoticons/\(pack).png"
        } else if source == "external" {
            imageUrl = pack
        } else {
            print("unknown emoticon pack source: \(source)")
        }
        
        guard let url = URL(string: imageUrl) else {
            return nil
        }
        
        if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            let frame = CGRect(x: coordinates.x, y: coordinates.y, width: 24, height: 24)
            if let cropped = image.cgImage?.cropping(to: frame) {
                let emoticon = UIImage(cgImage: cropped)
                return emoticon
            }
        }
        
        return nil
    }
    
    /**
     Retrieves a spacesuit image given a specific user identifier.
     
     :param: userId The identifier of the user being placed in a spacesuit.
     :returns: The finished spacesuit image.
     */
    public func getSpaceSuit(_ userId: Int) -> UIImage? {
        let imageUrl = "https://beam.pro/api/v1/users/\(userId)/avatar?w=64&h=64"
        
        guard let url = URL(string: imageUrl) else {
            return nil
        }
        
        if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            let fullsuit = getSpaceSuitWithAvatar(image)
            return fullsuit
        }
        
        return nil
    }
    
    /**
     Creates a spacesuit given a user's avatar image.
     
     :param: avatar An image of the user's avatar.
     :returns: The avatar placed inside a spacesuit.
     */
    fileprivate func getSpaceSuitWithAvatar(_ avatar: UIImage?) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 20, height: 20), false, 0)
        avatar?.draw(in: CGRect(x: 3, y: 4, width: 14, height: 14))
        UIImage(named: "Space Suit")?.draw(in: CGRect(x: 0, y: 0, width: 20, height: 20))
        let fullsuit = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return fullsuit ?? UIImage()
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
