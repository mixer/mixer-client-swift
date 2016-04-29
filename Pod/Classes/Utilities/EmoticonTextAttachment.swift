//
//  EmoticonTextAttachment.swift
//  Pods
//
//  Created by Jack Cook on 4/29/16.
//
//

import Foundation

public class EmoticonTextAttachment: NSTextAttachment {
    
    public override func attachmentBoundsForTextContainer(textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        let bounds = CGRectMake(0, -4, 20, 20)
        return bounds
    }
}
