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
    case dayName = "EEEE"
    case dateTimeUTC = "yyyy-MM-dd'T'HH:mm:ssZ"
    case dateTimeUTC2 = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    case dateTime = "yyyy-MM-dd HH:mm:ss"
    case dateNow = "EEEE dd MMMM"
    case timeAmPM = "hh:mm a"
    case timeOnly = "HH:mm"
    case TimeZoneAMPM = "yyyy/MM/dd HH:mm a"
    case DateOnly = "yyyy-MM-dd"
    case year = "yyyy"
    case month = "MM"
    case day = "dd"
    case hours = "HH"
    case min = "mm"
}

extension Date {
    
    func isEqualTo(_ date: Date) -> Bool {
        return self == date
    }
    
    func isGreaterThan(_ date: Date) -> Bool {
        return self > date
    }
    
    func isSmallerThan(_ date: Date) -> Bool {
        return self < date
    }
    
    func compareDates() -> dateCompared{
        let taskDate = self.UTCDate(format: .dateTimeUTC2, convertedFormat: .DateOnly)
        let currentDate = Date().UTCDate(format: .dateTimeUTC, convertedFormat: .DateOnly)
        if taskDate == currentDate
        {
            //todays tasks
            return .equal
            
        }else if taskDate > currentDate {
            //upcoming task
            return .ascending
        } else {
            //previous task
            return .descending
        }
    }
    
    func UTCDate(format: DateFormat, convertedFormat: DateFormat) -> String {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = format.rawValue
        dateFormatter1.timeZone = TimeZone(abbreviation: "UTC")
        let timeStamp = dateFormatter1.string(from: self)
        
        guard let date = dateFormatter1.date(from: timeStamp)else{
            return ""
        }
        dateFormatter1.dateFormat = convertedFormat.rawValue
        return dateFormatter1.string(from: date)
    }
    
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
    
    func utcDateToLocalDate(format: DateFormat, convertedFormat: DateFormat) -> Date? {
        let date = self.UTCToLocalDate(format: format, convertedFormat: convertedFormat)
        let returnDate =  date.dateToLocalDate(format: convertedFormat, convertedFormat: convertedFormat)
        return (returnDate ?? nil) ?? nil
    }

}

extension String{
    func dateBreak()-> String{
       let arr = self.components(separatedBy: "T")
        if arr.count > 1 {
            return arr[0]
        }
        return ""
    }
    
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
    
    func UTCDateToLocalDateIntTask(format: DateFormat, convertedFormat: DateFormat) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")!
        guard let date = dateFormatter.date(from: self)else{
            return 0
        }
        dateFormatter.dateFormat = convertedFormat.rawValue
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
    
    func dateToLocalDate(format: DateFormat, convertedFormat: DateFormat) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        guard let dateLocal = dateFormatter.date(from: self) else {
            return nil
        }
        return dateLocal
    }
}
