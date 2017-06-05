//
//  NSDate+fromMixer.swift
//  Mixer API
//
//  Created by Jack Cook on 7/6/15.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//

import Foundation

/// A helper class used to parse dates returned by Mixer's servers.
public extension Date {
    
    /**
     Creates an NSDate object from a date string.
     
     :param: dateString The raw string containing the data data.
     :returns: The NSDate object.
     */
    public static func fromMixer(_ dateString: String?) -> Date? {
        guard let string = dateString else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        
        return formatter.date(from: string)
    }
}
