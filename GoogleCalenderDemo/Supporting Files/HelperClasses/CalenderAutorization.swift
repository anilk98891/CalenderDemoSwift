//
//  CalenderAutorization.swift
//  GoogleCalenderDemo
//
//  Created by Anil Kumar on 21/02/19.
//  Copyright © 2019 Busywizzy. All rights reserved.
//

import Foundation
import EventKit

class CalenderAuth : NSObject{
    private override init() {}
    static let shared = CalenderAuth()
    let eventStore = EKEventStore()
    let isolationQueue = DispatchQueue.init(label: "com.isolation", attributes: .concurrent)
    var taskId = ""
    func authorized()-> EKAuthorizationStatus {
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            return .authorized
        case .denied:
            return .denied
        case .notDetermined:
            return .notDetermined
        default:
            return .restricted
        }
    }
    
    func insertEvent(dict: calenderobj) {
        let calendars = self.eventStore.calendars(for: .event)
        for calendar in calendars {
            isolationQueue.async(flags: .barrier) {
                if calendar.title == calenderName {
                    let startDate = dict.updated?.start?.UTCDateToLocalDate(format: DateFormat.dateTimeUTC, convertedFormat: DateFormat.dateTimeUTC)
                    var endDate = dict.endDate?.end?.UTCDateToLocalDate(format: DateFormat.dateTimeUTC, convertedFormat: DateFormat.dateTimeUTC)
                    if endDate == nil {
                        endDate = startDate?.addingTimeInterval(addTimeintervals.defaultEndTime) ?? Date()
                    }
                    let event = EKEvent(eventStore: self.eventStore)
                    event.calendar = calendar
                    event.title = dict.summary
                    event.startDate = startDate
                    event.endDate = endDate
                    //                let alaram = EKAlarm(absoluteDate: event.startDate)
                    //                event.addAlarm(alaram)
                    
                    //setup local notification
                    
                    LocalNotificationTrigger.shared.triggerLocalNotification(dict: dict) { (success) in
                        if success{
                            do {
                                try self.eventStore.save(event, span: .thisEvent)
                                
                            }
                            catch {
                                print("Error saving event in calendar")
                            }
                        }else {
                            
                        }
                    }
                }
            }
        }
    }
    
    func removeAllEventsMatchingPredicate(dict: calenderobj,completion:@escaping (Bool)->()) {
        let calendars = self.eventStore.calendars(for: .event)
        for calendar in calendars {
            if calendar.title == calenderTaskName {
                isolationQueue.async(flags: .barrier) {
                    
                    let startDate = dict.updated?.start?.UTCDateToLocalDate(format: DateFormat.dateTimeUTC, convertedFormat: DateFormat.dateTimeUTC)
                    let endDate = dict.endDate?.end?.UTCDateToLocalDate(format: DateFormat.dateTimeUTC, convertedFormat: DateFormat.dateTimeUTC)
                    
                    let predicate2 = self.eventStore.predicateForEvents(withStart: startDate ?? Date(), end: endDate ?? startDate?.addingTimeInterval(addTimeintervals.defaultEndTime) ?? Date(), calendars: nil)
                    
                    let eV = self.eventStore.events(matching: predicate2) as [EKEvent]
                    if eV.count > 0{
                        for i in eV {
                            if i.title == dict.summary {
                                do{
                                    (try self.eventStore.remove(i, span: EKSpan.thisEvent, commit: true))
                                    //                                break
                                }
                                catch let error {
                                    print("Error removing events: ", error)
                                    completion(false)
                                }
                            }
                        }
                        completion(true)
                    }else{
                        completion(true)
                    }
                }
            }
        }
    }
    
    func timeDiffrence (time1 : Date,time2 : Date) -> String {
        
        let difference = Calendar.current.dateComponents([.hour, .minute], from: time1, to: time2)
        let hoursInmint = difference.hour ?? 0
        let time = hoursInmint * 60 + difference.minute!
        return "\(time)"
    }
    
    func setTodayTaskData(date : Date)-> Bool {
        //after 9 am nad before 6 pm
        let taskDate = date.UTCToLocalDate(format: .dateTimeUTC2, convertedFormat: .timeOnly)
        if taskDate > "09:00" && taskDate < "18:00" {
            return true //for 6pm
        }
        return false //any other time
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
    
    func insertTask(dict: SubTask) {
        let calendars = self.eventStore.calendars(for: .event)
        for calendar in calendars {
            isolationQueue.async(flags: .barrier) {
                if calendar.title == calenderTaskName {
                    
                    let eventdate = (dict.due ?? dict.updated ?? "") // get time 2019-03-06'T'11:33:46.sssZ today
                    var startDate = eventdate.UTCDateToLocalDate(format: DateFormat.dateTimeUTC2, convertedFormat: DateFormat.dateTimeUTC2) //2019-03-06 11:33:46 UTC
                    let eventStatus = startDate?.compareDates()
                    
                    if eventStatus == .equal {
                        //for today
                        if self.setTodayTaskData(date: startDate ?? Date()){
                            
                            //set 6: pm
                            let taskDate = startDate?.UTCToLocalDate(format: .dateTimeUTC2, convertedFormat: .DateOnly) ?? ""
                            let date = self.dateToDateComponentTask(date: taskDate + " " + "18:00:00")
                            let calendar = Calendar(identifier: .gregorian)
                            startDate = calendar.date(from: date)!
                            
                        } else {
                            
                            //for today 9am
                            let taskDate = startDate?.UTCToLocalDate(format: .dateTimeUTC2, convertedFormat: .DateOnly) ?? ""
                            let date = self.dateToDateComponentTask(date: taskDate + " " + "09:00:00")
                            let calendar = Calendar(identifier: .gregorian)
                            startDate = calendar.date(from: date)!
                        }
                    }
                    else if eventStatus == .ascending {
                        //for tomorrow 9am
                        let taskDate = startDate?.UTCToLocalDate(format: .dateTimeUTC2, convertedFormat: .DateOnly) ?? ""
                        let date = self.dateToDateComponentTask(date: taskDate + " " + "09:00:00")
                        let calendar = Calendar(identifier: .gregorian)
                        startDate = calendar.date(from: date)!
                    }
                    
                    let event = EKEvent(eventStore: self.eventStore)
                    event.calendar = calendar
                    event.title = dict.title
                    event.startDate = startDate
                    event.endDate = startDate?.addingTimeInterval(addTimeintervals.defaultEndTime)
                    //                let alaram = EKAlarm(absoluteDate: event.startDate)
                    //                event.addAlarm(alaram)
                    
                    //setup local notification
                    
                    LocalNotificationTrigger.shared.triggerLocalNotificationTasks(dict: dict) { (success) in
                        if success{
                            do {
                                try self.eventStore.save(event, span: .thisEvent)
                                
                            }
                            catch {
                                print("Error saving event in calendar")
                            }
                        }else {
                            
                        }
                    }
                }
            }
        }
    }
    
    func removeAllTasksMatchingPredicate(dict: calenderobj,completion:@escaping (Bool)->()) {
        let calendars = self.eventStore.calendars(for: .event)
        for calendar in calendars {
            if calendar.title == calenderName {
                isolationQueue.async(flags: .barrier) {
                    
                    let startDate = dict.updated?.start?.UTCDateToLocalDate(format: DateFormat.dateTimeUTC, convertedFormat: DateFormat.dateTimeUTC)
                    let endDate = dict.endDate?.end?.UTCDateToLocalDate(format: DateFormat.dateTimeUTC, convertedFormat: DateFormat.dateTimeUTC)
                    
                    let predicate2 = self.eventStore.predicateForEvents(withStart: startDate ?? Date(), end: endDate ?? startDate?.addingTimeInterval(addTimeintervals.defaultEndTime) ?? Date(), calendars: nil)
                    
                    let eV = self.eventStore.events(matching: predicate2) as [EKEvent]
                    if eV.count > 0{
                        for i in eV {
                            if i.title == dict.summary {
                                do{
                                    (try self.eventStore.remove(i, span: EKSpan.thisEvent, commit: true))
                                    //                                break
                                }
                                catch let error {
                                    print("Error removing events: ", error)
                                    completion(false)
                                }
                            }
                        }
                        completion(true)
                    }else{
                        completion(true)
                    }
                }
            }
        }
    }
    
    func removeAllTasksMatchingPredicateTask(dict: SubTask,completion:@escaping (Bool)->()) {
        let calendars = self.eventStore.calendars(for: .event)
        for calendar in calendars {
            if calendar.title == calenderTaskName {
                isolationQueue.async(flags: .barrier) {
                    let date = dict.due ?? dict.updated ?? ""
                    var startDate = date.UTCDateToLocalDate(format: DateFormat.dateTimeUTC2, convertedFormat: DateFormat.dateTimeUTC2) ?? Date()
                    
                    //convert date to all current date :00:00:00
                    let taskDate = startDate.UTCToLocalDate(format: .dateTimeUTC, convertedFormat: .DateOnly)
                    let datecomponent = self.dateToDateComponentTask(date: taskDate + " " + "05:30:00")
                    let calendar = Calendar(identifier: .gregorian)
                    startDate = calendar.date(from: datecomponent)!
                    
                    
                    let predicate2 = self.eventStore.predicateForEvents(withStart: startDate, end: startDate.addingTimeInterval(addTimeintervals.defaultEndRemoveTime), calendars: nil)
                    
                    let eV = self.eventStore.events(matching: predicate2) as [EKEvent]
                    if eV.count > 0{
                        for i in eV {
                            if i.title == dict.title {
                                do{
                                    (try self.eventStore.remove(i, span: EKSpan.thisEvent, commit: true))
                                    //                                break
                                }
                                catch let error {
                                    print("Error removing events: ", error)
                                    completion(false)
                                }
                            }
                        }
                        completion(true)
                    }else{
                        completion(true)
                    }
                }
            }
        }
    }
    
    func createAppCalendarTask(completion: (Bool)->()) {
        let calendars = eventStore.calendars(for: .event) as [EKCalendar]
        var exists = false
        for calendar in calendars {
            if calendar.title == calenderTaskName {
                exists = true
            }
        }
        if exists == false {
            let newCalendar = EKCalendar(for:.event, eventStore:eventStore)
            newCalendar.title = calenderTaskName
            newCalendar.source = eventStore.defaultCalendarForNewEvents?.source
            do {
                try eventStore.saveCalendar(newCalendar, commit: true)
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
                
            }
        } else {
            completion(true)
        }
    }
    
    func createAppCalendar(completion: (Bool)->()) {
        let calendars = eventStore.calendars(for: .event) as [EKCalendar]
        var exists = false
        for calendar in calendars {
            if calendar.title == calenderName {
                exists = true
            }
        }
        if exists == false {
            let newCalendar = EKCalendar(for:.event, eventStore:eventStore)
            newCalendar.title = calenderName
            newCalendar.source = eventStore.defaultCalendarForNewEvents?.source
            do {
                try eventStore.saveCalendar(newCalendar, commit: true)
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
                
            }
        } else {
            completion(true)
        }
    }
}
