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
    
    func setTodayTaskData(date : Date)-> Bool {
        //after 9 am nad before 6 pm
        let taskTime = date.UTCToLocalDate(format: .dateTimeUTC2, convertedFormat: .timeOnly)
        if taskTime > "09:00" && taskTime < "18:00" {
            return true //for 6pm
        }
        return false //any other time
    }
    
    func getConvertedValidDate(dict: SubTask, completion:(DateComponents?,dateCompared)->()) {
        let eventdate = (dict.due ?? dict.updated ?? "") // get time 2019-03-06'T'11:33:46.sssZ today
        let startDate = eventdate.UTCDateToLocalDate(format: DateFormat.dateTimeUTC2, convertedFormat: DateFormat.dateTimeUTC2) //2019-03-06 11:33:46 UTC
        let eventStatus = startDate?.compareDates()
        
        if eventStatus == .equal {
            //for today
            if self.setTodayTaskData(date: startDate ?? Date()){
                
                //set 6: pm
                let taskDate = startDate?.UTCToLocalDate(format: .dateTimeUTC2, convertedFormat: .DateOnly) ?? ""
                let date = self.dateToDateComponentTask(date: taskDate + " " + "18:00:00")
                
                completion(date, .equal)
                
            } else {
                
                //for today 9am
                let taskDate = startDate?.UTCToLocalDate(format: .dateTimeUTC2, convertedFormat: .DateOnly) ?? ""
                let date = self.dateToDateComponentTask(date: taskDate + " " + "09:00:00")
                completion(date, .equal)

            }
        }
        else if eventStatus == .ascending {
            //for tomorrow 9am
            let taskDate = startDate?.UTCToLocalDate(format: .dateTimeUTC2, convertedFormat: .DateOnly) ?? ""
            let date = self.dateToDateComponentTask(date: taskDate + " " + "09:00:00")
            
            completion(date, .ascending)

        }
        else {
            //yesterday
            completion(nil, .descending)
        }
    }
    
    func triggerLocalNotificationTasks(dict: SubTask, completion:(Bool)->()) {
        
        let content = UNMutableNotificationContent()
        content.title = dict.title ?? ""
        content.body = dict.notes ?? "Church Task"
        content.categoryIdentifier = "alarm"
        //            content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        self.getConvertedValidDate(dict: dict) { (date, value) in
            switch value {
            case .equal:

                let dateComponents = date
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents ?? DateComponents(), repeats: true)
                
                let request = UNNotificationRequest(identifier: calenderAlarm, content: content, trigger: trigger)
                center.add(request)
                print("trigger for: \(dateComponents) ")
                completion(true)
            case .ascending:
                let dateComponents = date
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents ?? DateComponents(), repeats: true)
                
                let request = UNNotificationRequest(identifier: calenderAlarm, content: content, trigger: trigger)
                center.add(request)
                print("trigger for: \(dateComponents) ")
                completion(true)
            case .descending:
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
    
    func dateToDateComponentTask(date: String)->DateComponents {
        let year = {
            return date.UTCDateToLocalDateIntTask(format: DateFormat.dateTime, convertedFormat: DateFormat.year)
        }
        let month = {
            return date.UTCDateToLocalDateIntTask(format: DateFormat.dateTime, convertedFormat: DateFormat.month)
        }
        let day = {
            return date.UTCDateToLocalDateIntTask(format: DateFormat.dateTime, convertedFormat: DateFormat.day)
        }
        let hour = {
            return date.UTCDateToLocalDateIntTask(format: DateFormat.dateTime, convertedFormat: DateFormat.hours)
        }
        let min = {
            return date.UTCDateToLocalDateIntTask(format: DateFormat.dateTime, convertedFormat: DateFormat.min)
        }
        let components = DateComponents(year: year(), month: month(), day: day(), hour: hour(), minute: min())
        return components
    }
}
