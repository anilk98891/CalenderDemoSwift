//
//  Constants.swift
//  GoogleCalenderDemo
//
//  Created by Anil Kumar on 18/02/19.
//  Copyright © 2019 Busywizzy. All rights reserved.
//

import Foundation
typealias completionHandlerButton = () -> ()

enum calenderApi :String {
    case kapiKey = "AIzaSyCC_NIUvuKqEMomlTNh7KNS-TgT1t7WK98"
}

var defaultTime = TimeInterval(2 * 60 * 60)
var calenderName = "Church Calender"
var calenderAlarm = "com.churuch.alarm"

var googleApiKey = "AIzaSyCC_NIUvuKqEMomlTNh7KNS-TgT1t7WK98"
let BaseURL = "https://www.googleapis.com/calendar/v3/calendars/busywizzy1@gmail.com/events?key=\(googleApiKey)";
