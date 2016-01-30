//
//  ChatRoutes.swift
//  Beam
//
//  Created by Jack Cook on 1/8/16.
//  Copyright © 2016 MCProHosting. All rights reserved.
//

public class ChatRoutes {
    
    // MARK: Acting on Chat
    
    public func deleteAllChatMessages(channelId: Int, completion: (success: Bool, error: BeamRequestError?) -> Void) {
        self.deleteMessagesByEndpoint("/chats/\(channelId)/message", completion: completion)
    }
    
    public func deleteChatMessage(channelId: Int, messageId: String, completion: (success: Bool, error: BeamRequestError?) -> Void) {
        self.deleteMessagesByEndpoint("/chats/\(channelId)/message/\(messageId)", completion: completion)
    }
    
    private func deleteMessagesByEndpoint(endpoint: String, completion: (success: Bool, error: BeamRequestError?) -> Void) {
        BeamRequest.request(endpoint, requestType: "DELETE") { (json, error) -> Void in
            guard let _ = json else {
                completion(success: false, error: error)
                return
            }
            
            completion(success: error == nil, error: error)
        }
    }
    
    // MARK: Retrieving Chat Data
    
    public func getChatDetailsById(channelId: Int, completion: (endpoints: [String]?, authKey: String?, error: BeamRequestError?) -> Void) {
        // TODO: Create a helper class to store all details retrieved with this method
        
        BeamRequest.request("/chats/\(channelId)", requestType: "GET") { (json, error) -> Void in
            guard let json = json else {
                completion(endpoints: nil, authKey: nil, error: error)
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
            
            completion(endpoints: retrievedEndpoints, authKey: retrievedAuthKey, error: error)
        }
    }
    
    public func getMessagesByChannel(channelId: Int, completion: (messages: [BeamMessage]?, error: BeamRequestError?) -> Void) {
        BeamRequest.request("/chats/\(channelId)/message", requestType: "GET") { (json, error) -> Void in
            guard let json = json,
                let messages = json.array else {
                    completion(messages: nil, error: error)
                    return
            }
            
            var retrievedMessages = [BeamMessage]()
            
            for message in messages {
                let retrievedMessage = BeamMessage(json: message)
                retrievedMessages.append(retrievedMessage)
            }
            
            completion(messages: retrievedMessages, error: error)
        }
    }
    
    public func getViewersByChannel(channelId: Int, completion: (users: [ChannelViewer]?, error: BeamRequestError?) -> Void) {
        self.getViewersByEndpoint("/chats/\(channelId)/users", params: [String: String](), completion: completion)
    }
    
    public func getViewersByChannelWithQuery(channelId: Int, query: String, completion: (users: [ChannelViewer]?, error: BeamRequestError?) -> Void) {
        self.getViewersByEndpoint("/chats/\(channelId)/users/search", params: ["username": query], completion: completion)
    }
    
    private func getViewersByEndpoint(endpoint: String, params: [String: String], completion: (users: [ChannelViewer]?, error: BeamRequestError?) -> Void) {
        BeamRequest.request(endpoint, requestType: "GET", params: params) { (json, error) -> Void in
            guard let json = json,
                let users = json.array else {
                    completion(users: nil, error: error)
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
            
            completion(users: retrievedUsers, error: error)
        }
    }
    
    // MARK: Retrieving Emoticons
    
    public func getEmoticon(component: BeamMessageComponent, completion: (emoticon: UIImage?, error: BeamRequestError?) -> Void) {
        guard let source = component.source,
            pack = component.pack,
            coordinates = component.coordinates else {
                completion(emoticon: nil, error: .Unknown)
                return
        }
        
        var imageUrl = ""
        
        if source == "builtin" {
            imageUrl = "https://beam.pro/_latest/emoticons/\(pack).png"
        } else if source == "external" {
            imageUrl = pack
        } else {
            print("unknown emoticon pack source: \(source)")
            completion(emoticon: nil, error: .Unknown)
            return
        }
        
        BeamRequest.imageRequest(imageUrl) { (image, error) -> Void in
            guard let image = image else {
                completion(emoticon: nil, error: error)
                return
            }
            
            let frame = CGRectMake(coordinates.x, coordinates.y, 22, 22)
            if let cropped = CGImageCreateWithImageInRect(image.CGImage, frame) {
                let emoticon = UIImage(CGImage: cropped)
                completion(emoticon: emoticon, error: nil)
            } else {
                completion(emoticon: nil, error: .Unknown)
            }
        }
    }
    
    public func getSpaceSuit(userId: Int, completion: (spacesuit: UIImage?, error: BeamRequestError?) -> Void) {
        let imageUrl = "https://images.beam.pro/64x64/https://uploads.beam.pro/avatar/\(userId).jpg"
        
        BeamRequest.imageRequest(imageUrl) { (image, error) -> Void in
            let fullsuit = self.getSpaceSuitWithAvatar(image)
            completion(spacesuit: fullsuit, error: nil)
        }
    }
    
    private func getSpaceSuitWithAvatar(avatar: UIImage?) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(20, 20), false, 0)
        avatar?.drawInRect(CGRectMake(3, 4, 14, 14))
        UIImage(named: "Space Suit")?.drawInRect(CGRectMake(0, 0, 20, 20))
        let fullsuit = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return fullsuit
    }
}

public struct ChannelViewer {
    public var username: String!
    public var roles: [BeamGroup]!
    public var userId: Int!
}
