//
//  Constants.swift
//  GoogleCalenderDemo
//
//  Created by Anil Kumar on 18/02/19.
//  Copyright © 2019 Busywizzy. All rights reserved.
//

import Foundation
typealias completionHandlerButton = () -> ()

enum listType: String {
    case kEvents = "events"
    case kTasks = "tasks"
}
struct userDefaultsConstants {
    static var authToken = "googleToken"
}

let workerQueue = DispatchQueue.init(label: "com.worker", attributes: .concurrent)

var defaultTime = TimeInterval(2 * 60 * 60)
var calenderName = "Church Calender"
var calenderAlarm = "com.churuch.alarm"

var googleApiKey = "AIzaSyCC_NIUvuKqEMomlTNh7KNS-TgT1t7WK98"
var baseURL = "https://www.googleapis.com/"

enum GetApiURL {
    case kGetEvents
    case kGetTasks
    case kGetSubTasks
    
    func typeURL()-> String {
        let taskID = CalenderAuth.shared.taskId
        switch self {
        case .kGetEvents:
            return baseURL + "calendar/v3/calendars/busywizzy1@gmail.com/events?key=\(googleApiKey)"
        case .kGetTasks:
            return baseURL + "tasks/v1/users/@me/lists?pp=1&key=\(googleApiKey)"
        case .kGetSubTasks:
            return baseURL + "tasks/v1/lists/\(taskID)/tasks?&key=\(googleApiKey)"
        }
    }
}
