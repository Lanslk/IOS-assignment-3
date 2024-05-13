//
//  Schedule.swift
//  calendar
//
//  Created by yuteng Lan on 2024/5/8.
//

import Foundation

class Schedule: ObservableObject {
    @Published var activities: [Activity] = []
}

class Activity: Identifiable {
    var id = UUID()
    var date: Date = Date()  // Only the date part, no time
    var beginTime: Date = Date()
    var endTime: Date = Date()
    var name: String = ""
    var description: String = ""
    var alert: Bool = false
    var alertTime: Date = Date()
    var weather: String = ""
    var temp: String = ""
    
    init() {}
}
