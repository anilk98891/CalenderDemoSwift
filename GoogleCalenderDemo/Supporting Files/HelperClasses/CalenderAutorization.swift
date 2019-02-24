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
                        endDate = startDate?.addingTimeInterval(defaultTime) ?? Date()
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
            if calendar.title == calenderName {
                isolationQueue.async(flags: .barrier) {
                    
                    let startDate = dict.updated?.start?.UTCDateToLocalDate(format: DateFormat.dateTimeUTC, convertedFormat: DateFormat.dateTimeUTC)
                    let endDate = dict.endDate?.end?.UTCDateToLocalDate(format: DateFormat.dateTimeUTC, convertedFormat: DateFormat.dateTimeUTC)
                    
                    let predicate2 = self.eventStore.predicateForEvents(withStart: startDate ?? Date(), end: endDate ?? startDate?.addingTimeInterval(defaultTime) ?? Date(), calendars: nil)
                    
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
