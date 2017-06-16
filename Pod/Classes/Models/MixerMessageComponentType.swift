//
//  MixerMessageComponentType.swift
//  Mixer API
//
//  Created by Jack Cook on 7/5/15.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//

/// The type of a chat message component.
public enum MixerMessageComponentType: String {
    case emoticon = "emoticon"
    case link = "link"
    case me = "me"
    case spaceSuit = "inaspacesuit"
    case tag = "tag"
    case text = "text"
    case unknown
}
