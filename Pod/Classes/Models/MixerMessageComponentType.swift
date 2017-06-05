//
//  MixerMessageComponentType.swift
//  Mixer API
//
//  Created by Jack Cook on 7/5/15.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//

/// The type of a chat message component.
public enum MixerMessageComponentType: String {
    case Emoticon = "emoticon"
    case Link = "link"
    case Me = "me"
    case SpaceSuit = "inaspacesuit"
    case Tag = "tag"
    case Text = "text"
    case Unknown
}
