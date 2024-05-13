//
//  Schedule.swift
//  calendar
//
//  Created by yuteng Lan on 2024/5/8.
//

import Foundation
import SwiftData

@Model
class Activity: Identifiable {
    var id: String
    var date: Date = Date()  // Only the date part, no time
    var beginTime: Date = Date()
    var endTime: Date = Date()
    var name: String = ""
    var taskDescription: String = ""
    var alert: Bool = false
    var alertTime: Date = Date()
    var weather: String = ""
    var temp: String = ""
    
    init() {
        id = UUID().uuidString
    }
}
