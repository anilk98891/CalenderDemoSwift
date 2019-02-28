//
//  NSDate+Extension.swift
//  Gifted
//
//  Created by Prince Agrawal on 28/07/16.
//  Copyright © 2016 Book Your Game Fitness Pvt. Ltd. All rights reserved.
//


import Foundation
import UIKit

enum DateFormat: String {
    case dateTimeAMPM = "yyyy/MM/dd hh:mm a"
    case dateMonth = "dd MMM"
    case dayDate = "EEEE hh:mm a"
    case dateTimeUTC = "yyyy-MM-dd'T'HH:mm:ssZ"
    case dateTimeUTC2 = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    case dateTime = "yyyy-MM-dd HH:mm:ss"
    case dateNow = "EEEE dd MMMM"
    case timeAmPM = "hh:mm a"
    case timeOnly = "hh:mm"
    case TimeZoneAMPM = "yyyy/MM/dd HH:mm a"
    case year = "yyyy"
    case month = "MM"
    case day = "dd"
    case hours = "HH"
    case min = "mm"
}

extension Date {
    //Convert date into String Format in GMT
    func UTCToLocalDate(format: DateFormat, convertedFormat: DateFormat) -> String {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = format.rawValue
        dateFormatter1.timeZone = TimeZone(abbreviation: "UTC")
        let timeStamp = dateFormatter1.string(from: self)
        
        guard let date = dateFormatter1.date(from: timeStamp)else{
            return ""
        }
        dateFormatter1.dateFormat = convertedFormat.rawValue
        dateFormatter1.timeZone = NSTimeZone.local
        return dateFormatter1.string(from: date)
    }
  
}

extension String{
    
    func DateFromString(format: DateFormat, convertedFormat: DateFormat ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")!
        guard let date = dateFormatter.date(from: self)else{
            return ""
        }
        dateFormatter.dateFormat = convertedFormat.rawValue
        dateFormatter.timeZone = NSTimeZone.local

        return dateFormatter.string(from: date) 
    }
    
    func UTCDateToLocalDateInt(format: DateFormat, convertedFormat: DateFormat) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")!
        guard let date = dateFormatter.date(from: self)else{
            return 0
        }
        dateFormatter.dateFormat = convertedFormat.rawValue
        dateFormatter.timeZone = NSTimeZone.local
        let str = dateFormatter.string(from: date)
        return Int(str)
    }
    
    func UTCDateToLocalDate(format: DateFormat, convertedFormat: DateFormat) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = convertedFormat.rawValue
        dateFormatter.timeZone = NSTimeZone.local
        guard let dateLocal = dateFormatter.date(from: self) else {
            return nil
        }
        return dateLocal
    }
}
