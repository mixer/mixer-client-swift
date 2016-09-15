//
//  NSDate+fromBeam.swift
//  Beam API
//
//  Created by Jack Cook on 7/6/15.
//  Copyright © 2015 MCProHosting. All rights reserved.
//

import Foundation

/// A helper class used to parse dates returned by Beam's servers.
public extension Date {
    
    /**
     Creates an NSDate object from a date string.
     
     :param: dateString The raw string containing the data data.
     :returns: The NSDate object.
     */
    public static func fromBeam(_ dateString: String?) -> Date? {
        guard let string = dateString else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        
        return formatter.date(from: string)
    }
}
