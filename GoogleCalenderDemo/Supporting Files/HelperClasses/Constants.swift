//
//  Constants.swift
//  GoogleCalenderDemo
//
//  Created by Anil Kumar on 18/02/19.
//  Copyright © 2019 Busywizzy. All rights reserved.
//

import Foundation
typealias completionHandlerButton = () -> ()

struct userDefaultsConstants {
    static var authMyToken = "googleMyToken"
    static var authClientAccessToken = "googleClientToken"
    static var kLastSyncTime = "lastSyncTime"
}

enum googleInfoKeys : String {
    case refreshToken = "1/0jCcycrB4U3l879PSbQEf59hLOznbHt8jRvoMF_Q4Fs"
    case googleApiKey = "AIzaSyCC_NIUvuKqEMomlTNh7KNS-TgT1t7WK98"
    case googleClientSecret = "4Xb90bIWLenMxG5yXg2B8UPL"
    case googleClientId = "290826560562-6iflh5ena0avsg2rd9sjvbv36t3vqes1.apps.googleusercontent.com"
}

enum appConstants : String {
    case KAppName = "App"
}

enum appconfig : Int {
    case kSyncTime = 60
}

struct addTimeintervals  {
    static var defaultTaskCurrentTime = TimeInterval(60)
    static var defaultStartTaskTime = TimeInterval(9 * 60 * 60)
    static var defaultEndTime = TimeInterval(2 * 60 * 60)
    static var defaultEndRemoveTime = TimeInterval(23 * 60 * 60)
}

let workerQueue = DispatchQueue.init(label: "com.worker", attributes: .concurrent)

var calenderTaskName = "Church Task Calender"
var calenderName = "Church Calender"
var calenderAlarm = "com.churuch.alarm"

enum dateCompared {
    case equal
    case ascending
    case descending
}

enum GetApiURL {
    case kAuthGoogle
    case kGetEvents
    case kGetTasks
    case kGetSubTasks
    
    func typeURL()-> String {
        let baseURL = "https://www.googleapis.com/"
        let taskID = CalenderAuth.shared.taskId
        switch self {
        case .kAuthGoogle:
            return baseURL + "oauth2/v4/token"
        case .kGetEvents:
            return baseURL + "calendar/v3/calendars/busywizzy1@gmail.com/events?key=\(googleInfoKeys.googleApiKey.rawValue)"
        case .kGetTasks:
            return baseURL + "tasks/v1/users/@me/lists?key=\(googleInfoKeys.googleApiKey.rawValue)"
        case .kGetSubTasks:
            return baseURL + "tasks/v1/lists/\(taskID)/tasks?&key=\(googleInfoKeys.googleApiKey.rawValue)"
        }
    }
}
