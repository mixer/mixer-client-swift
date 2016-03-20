//
//  NSDate+fromBeam.swift
//  Beam API
//
//  Created by Jack Cook on 7/6/15.
//  Copyright © 2015 MCProHosting. All rights reserved.
//

import Foundation

/// A helper class used to parse dates returned by Beam's servers.
public extension NSDate {
    
    /**
     Creates an NSDate object from a date string.
     
     :param: dateString The raw string containing the data data.
     :returns: The NSDate object.
     */
    public class func fromBeam(dateString: String?) -> NSDate? {
        guard let string = dateString else {
            return nil
        }
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = formatter.dateFromString(string) {
            return date
        } else {
            return nil
        }
    }
}
