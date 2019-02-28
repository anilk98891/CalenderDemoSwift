//
//  LocalNotification.swift
//  GoogleCalenderDemo
//
//  Created by Anil Kumar on 22/02/19.
//  Copyright © 2019 Busywizzy. All rights reserved.
//

import Foundation
import UserNotifications

class LocalNotificationTrigger : NSObject{
    private override init() {}
    static let shared = LocalNotificationTrigger()
    let center = UNUserNotificationCenter.current()
    let isolationQueue = DispatchQueue.init(label: "com.isolation", attributes: .concurrent)

    func authorized(completion:@escaping (Bool)->()){
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func triggerLocalNotification(dict: calenderobj, completion:(Bool)->()) {
        
        let content = UNMutableNotificationContent()
        content.title = dict.summary ?? ""
        content.body = dict.description ?? "Church Event"
        content.categoryIdentifier = "alarm"
        //            content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        if let updated = dict.updated?.start{
            //only for upcoming notification
            if updated >= Date().UTCToLocalDate(format: DateFormat.dateTimeUTC, convertedFormat: DateFormat.dateTimeUTC) {
            let dateComponents = dateToDateComponent(date: updated)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let request = UNNotificationRequest(identifier: calenderAlarm, content: content, trigger: trigger)
            center.add(request)
            print("trigger for: \(dateComponents) ")
            }
            completion(true)
        }
        else {
            completion(false)
        }
    }
    
    func deleteAllNotification(completion:@escaping (Bool)->()) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification:UNNotificationRequest in notificationRequests {
                if notification.identifier == calenderAlarm {
                    identifiers.append(notification.identifier)
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
            print("delete all")
            completion(true)
        }
    }
    
    func dateToDateComponent(date: String)->DateComponents{
        let year = {
            return date.UTCDateToLocalDateInt(format: DateFormat.dateTimeUTC, convertedFormat: DateFormat.year)
        }
        let month = {
            return date.UTCDateToLocalDateInt(format: DateFormat.dateTimeUTC, convertedFormat: DateFormat.month)
        }
        let day = {
            return date.UTCDateToLocalDateInt(format: DateFormat.dateTimeUTC, convertedFormat: DateFormat.day)
        }
        let hour = {
            return date.UTCDateToLocalDateInt(format: DateFormat.dateTimeUTC, convertedFormat: DateFormat.hours)
        }
        let min = {
            return date.UTCDateToLocalDateInt(format: DateFormat.dateTimeUTC, convertedFormat: DateFormat.min)
        }
        let components = DateComponents(year: year(), month: month(), day: day(), hour: hour(), minute: min())
        return components
    }
}
/*
 //
 //  LocalNotification.swift
 //  GoogleCalenderDemo
 //
 //  Created by Anil Kumar on 22/02/19.
 //  Copyright © 2019 Busywizzy. All rights reserved.
 //
 
 import Foundation
 import UserNotifications
 
 class LocalNotificationTrigger : NSObject{
 private override init() {}
 static let shared = LocalNotificationTrigger()
 let center = UNUserNotificationCenter.current()
 let isolationQueue = DispatchQueue.init(label: "com.isolation", attributes: .concurrent)
 
 func authorized(completion:@escaping (Bool)->()){
 center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
 if granted {
 completion(true)
 } else {
 completion(false)
 }
 }
 }
 
 func triggerLocalNotification(dict: calenderobj, completion:(Bool)->()) {
 
 let content = UNMutableNotificationContent()
 content.title = dict.summary ?? ""
 content.body = dict.description ?? "Church Event"
 content.categoryIdentifier = "alarm"
 //            content.userInfo = ["customData": "fizzbuzz"]
 content.sound = UNNotificationSound.default
 if let updated = dict.updated?.start{
 //only for upcoming notification
 if updated >= Date().UTCToLocalDate(format: DateFormat.dateTimeUTC, convertedFormat: DateFormat.dateTimeUTC) {
 let dateComponents = dateToDateComponent(date: updated)
 let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
 
 let request = UNNotificationRequest(identifier: calenderAlarm, content: content, trigger: trigger)
 center.add(request)
 print("trigger for: \(dateComponents) ")
 }
 completion(true)
 }
 else {
 completion(false)
 }
 }
 
 func triggerLocalNotification(dict: SubTask, completion:(Bool)->()) {
 
 let content = UNMutableNotificationContent()
 content.title = dict.title ?? ""
 content.body = dict.notes ?? "Church Tasks"
 content.categoryIdentifier = "alarm"
 //            content.userInfo = ["customData": "fizzbuzz"]
 content.sound = UNNotificationSound.default
 if let updated = dict.updated{
 //only for upcoming notification
 if updated >= Date().UTCToLocalDate(format: DateFormat.dateTimeUTC2, convertedFormat: DateFormat.dateTimeUTC) {
 let dateComponents = dateToDateComponent(date: updated)
 let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
 
 let request = UNNotificationRequest(identifier: calenderAlarm, content: content, trigger: trigger)
 center.add(request)
 print("trigger for: \(dateComponents) ")
 }
 completion(true)
 }
 else {
 completion(false)
 }
 }
 
 func deleteAllNotification(completion:@escaping (Bool)->()) {
 UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
 var identifiers: [String] = []
 for notification:UNNotificationRequest in notificationRequests {
 if notification.identifier == calenderAlarm {
 identifiers.append(notification.identifier)
 }
 }
 UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
 print("delete all")
 completion(true)
 }
 }
 
 func dateToDateComponent(date: String)->DateComponents{
 let year = {
 return date.UTCDateToLocalDateInt(format: DateFormat.dateTimeUTC, convertedFormat: DateFormat.year)
 }
 let month = {
 return date.UTCDateToLocalDateInt(format: DateFormat.dateTimeUTC, convertedFormat: DateFormat.month)
 }
 let day = {
 return date.UTCDateToLocalDateInt(format: DateFormat.dateTimeUTC, convertedFormat: DateFormat.day)
 }
 let hour = {
 return date.UTCDateToLocalDateInt(format: DateFormat.dateTimeUTC, convertedFormat: DateFormat.hours)
 }
 let min = {
 return date.UTCDateToLocalDateInt(format: DateFormat.dateTimeUTC, convertedFormat: DateFormat.min)
 }
 let components = DateComponents(year: year(), month: month(), day: day(), hour: hour(), minute: min())
 return components
 }
 }
*/
