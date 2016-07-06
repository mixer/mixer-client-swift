//
//  EmoticonTextAttachment.swift
//  Beam
//
//  Created by Jack Cook on 7/6/16.
//  Copyright © 2016 MCProHosting. All rights reserved.
//

import Foundation

public class EmoticonTextAttachment: NSTextAttachment {
    
    public override func attachmentBoundsForTextContainer(textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        let bounds = CGRectMake(0, -4, 20, 20)
        return bounds
    }
}
