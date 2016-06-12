//
//  BeamMessage.swift
//  Beam API
//
//  Created by Jack Cook on 4/25/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import SwiftyJSON

/// A chat message object.
public struct BeamMessage {
    
    /// The components that make up the chat message.
    public let components: [BeamMessageComponent]!
    
    /// The id of the channel that the message was sent to.
    public let channel: Int?
    
    /// The message's identifier.
    public let id: String?
    
    /// The id of the user who sent the message.
    public let userId: Int?
    
    /// The name of the user who sent the message.
    public let userName: String?
    
    /// The roles held by the user who sent the message.
    public let userRoles: [BeamGroup]?
    
    /// An attributed string containing all of the message's contents.
    public let attributedString: NSAttributedString
    
    /// Used to initialize a chat message given JSON data.
    init(json: JSON) {
        components = [BeamMessageComponent]()
        
        if let message = json["message"].dictionary,
            meta = message["meta"]?.dictionary {
                var me = false
                
                if let flag = meta["me"]?.bool {
                    me = flag
                }
                
                if let components = message["message"]?.array {
                    for component in components {
                        let message_component = BeamMessageComponent(json: component, me: me)
                        self.components.append(message_component)
                    }
                }
        }
        
        channel = json["channel"].int
        id = json["id"].string
        userId = json["user_id"].int
        userName = json["user_name"].string
        
        userRoles = [BeamGroup]()
        if let roles = json["user_roles"].array {
            for role in roles {
                if let roleString = role.string {
                    if let user_role = BeamGroup(rawValue: roleString) {
                        userRoles!.append(user_role)
                    } else {
                        userRoles!.append(BeamGroup.User)
                    }
                }
            }
        }
        
        // create attributed string
        
        var color = chatColorForGroups([BeamGroup.User])
        
        if let roles = userRoles {
            color = chatColorForGroups(roles)
        }
        
        let font = UIFont(name: "AvenirNext-Regular", size: 15)!
        let name = NSMutableAttributedString(string: userName!)
        name.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, name.length))
        name.addAttribute(NSFontAttributeName, value: font, range: NSMakeRange(0, name.length))
        
        var me = false
        var messageString = NSMutableAttributedString()
        
        for component in components {
            var string = NSAttributedString()
            
            switch component.type {
            case .Emoticon:
                BeamClient.sharedClient.chat.getEmoticon(component, completion: { (emoticon, error) -> Void in
                    if let emoticon = emoticon {
                        let attachment = EmoticonTextAttachment()
                        attachment.image = emoticon
                        
                        let position = messageString.length
                        
                        let emoticon = NSMutableAttributedString()
                        emoticon.appendAttributedString(NSAttributedString(string: " "))
                        emoticon.appendAttributedString(NSAttributedString(attachment: attachment))
                        emoticon.appendAttributedString(NSAttributedString(string: " "))
                        messageString.insertAttributedString(emoticon, atIndex: position)
                    }
                })
            case .Link:
                string = NSAttributedString(string: component.text!, attributes: [NSLinkAttributeName: NSMakeRange(0, component.text!.characters.count)])
            case .Me:
                string = NSAttributedString(string: component.text!)
                me = true
            case .SpaceSuit:
                let position = messageString.length
                
                BeamClient.sharedClient.chat.getSpaceSuit(component.userId!, completion: { (spacesuit, error) -> Void in
                    if let spacesuit = spacesuit {
                        let attachment = EmoticonTextAttachment()
                        attachment.image = spacesuit
                        
                        let spacesuit = NSMutableAttributedString()
                        spacesuit.appendAttributedString(NSAttributedString(string: " "))
                        spacesuit.appendAttributedString(NSAttributedString(attachment: attachment))
                        spacesuit.appendAttributedString(NSAttributedString(string: " "))
                        
                        messageString.insertAttributedString(spacesuit, atIndex: position)
                    }
                })
            case .Tag:
                string = NSAttributedString(string: component.text!)
            case .Text:
                string = NSAttributedString(string: component.text!)
            case .Unknown:
                if let text = component.text {
                    string = NSAttributedString(string: text)
                }
            }
            
            messageString.appendAttributedString(string)
        }
        
        let tmp = messageString
        
        messageString = NSMutableAttributedString(string: "   ")
        messageString.appendAttributedString(tmp)
        
        messageString.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSMakeRange(0, messageString.length))
        messageString.addAttribute(NSFontAttributeName, value: font, range: NSMakeRange(0, messageString.length))
        
        if me {
            let meFont = UIFont(name: "AvenirNext-Italic", size: 15)!
            messageString.addAttribute(NSFontAttributeName, value: meFont, range: NSMakeRange(0, messageString.length))
            
            let color = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
            messageString.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, messageString.length))
        }
        
        name.appendAttributedString(messageString)
        
        attributedString = name
    }
}
