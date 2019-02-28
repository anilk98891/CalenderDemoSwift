//
//  TasksDataModel.swift
//  GoogleCalenderDemo
//
//  Created by Anil Kumar on 27/02/19.
//  Copyright © 2019 Busywizzy. All rights reserved.
//

import Foundation
import ObjectMapper
class Task: Mappable {
    var id : String?
    var title : String?
    var selfLink : String?
    var subTask = [SubTask]()
    required init?(map: Map) {
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        selfLink <- map["selfLink"]
    }
}
class SubTask: Mappable {
    var id : String?
    var title : String?
    var updated : String?
    var selfLink : String?
    var notes : String?
    var due : String?
    required init?(map: Map) {
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        updated <- map["updated"]
        selfLink <- map["selfLink"]
        notes <- map["notes"]
        due <- map["due"]
    }
}
