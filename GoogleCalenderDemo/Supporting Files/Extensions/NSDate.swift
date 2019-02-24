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
    func stringFromDate(format: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        return dateFormatter.string(from: self)
    }
    
    //Convert String into date Format in UTC to local timeZone Accordingly
    func DateFromString(format: DateFormat , dateString: String) -> String {
        let gmtTimeString = dateString
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        guard let date = formatter.date(from: gmtTimeString) else {
            print("can't convert time string")
            return gmtTimeString
        }
        let timeZone = NSTimeZone.local
        let timeZoneOffset = timeZone.secondsFromGMT(for: date)
        print(timeZoneOffset, "hours offset for timezone", timeZone)
        let utcDate = date.addingTimeInterval(TimeInterval(-timeZoneOffset))
        let localTimeString = formatter.string(from: utcDate)
        return localTimeString
    }
    
    //Convert String Date to UTC format
    internal func convertStringToDateUTC(date ofString:String, instanceOf DateFormat:DateFormat) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.rawValue
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")!
        let date = dateFormatter.date(from: ofString)
        if let dateObject = date {
            return dateObject // return the date if date is not equal to null
        }
        return date!
    }
    
    // Convert Date to String in UTC
    internal func convertDateToStringUTC(instance OfDate:Date, instanceOf DateFormat:DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.rawValue
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")!
        return dateFormatter.string(from:OfDate)
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
    
    func UTCToLocalDate(format: DateFormat, date1:Date, convertedFormat: DateFormat) -> String {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = format.rawValue
        dateFormatter1.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter1.dateFormat = convertedFormat.rawValue
        dateFormatter1.timeZone = NSTimeZone.local
        let timeStamp = dateFormatter1.string(from: date1)
        return timeStamp
    }
}

extension UIViewController{
    func UTCToLocal(format: DateFormat, date1:String, convertedFormat: DateFormat) -> String {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = format.rawValue
        dateFormatter1.timeZone = TimeZone(abbreviation: "UTC")
        guard let date = dateFormatter1.date(from: date1)else{
            return date1
        }
        dateFormatter1.dateFormat = convertedFormat.rawValue
        dateFormatter1.timeZone = NSTimeZone.local
        let timeStamp = dateFormatter1.string(from: date)
        return timeStamp
    }
    
    //Convert String Date to UTC format
    func convertStringToDateUTC(date ofString:String, instanceOf DateFormat:DateFormat) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.rawValue
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")!
        let date = dateFormatter.date(from: ofString)
        if let dateObject = date {
            return dateObject // return the date if date is not equal to null
        }
        return date!
    }
    
    func convertDateToStringUTC(date ofDate:Date, instanceOf DateFormat:DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.rawValue
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")!
        let dateObject = dateFormatter.string(from: ofDate)
        return dateObject // return the date if date is not equal to null
    }
    
    
    
    func UTCDateToLocalDate(format: DateFormat, date1:Date, convertedFormat: DateFormat) -> Date {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = format.rawValue
        dateFormatter1.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter1.dateFormat = convertedFormat.rawValue
        dateFormatter1.timeZone = NSTimeZone.local
        let dateStr = date1.stringFromDate(format: convertedFormat)
        let date = dateFormatter1.date(from: dateStr)
        if let dateObject = date {
            return dateObject // return the date if date is not equal to null
        }
        return date!
    }
}
