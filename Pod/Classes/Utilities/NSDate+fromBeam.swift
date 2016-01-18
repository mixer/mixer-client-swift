//
//  NSDate+fromBeam.swift
//  Beam API
//
//  Created by Jack Cook on 7/6/15.
//  Copyright © 2015 MCProHosting. All rights reserved.
//

import Foundation

public extension NSDate {
    
    public class func fromBeam(dateString: String?) -> NSDate {
        guard let string = dateString else {
            return NSDate(timeIntervalSince1970: 0)
        }
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = formatter.dateFromString(string) {
            return date
        } else {
            return NSDate(timeIntervalSince1970: 0)
        }
    }
}
