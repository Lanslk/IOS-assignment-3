//
//  Schedule.swift
//  calendar
//
//  Created by yuteng Lan on 2024/5/8.
//

import Foundation

class Schedule: ObservableObject {
    
    
    var activities:[Activity] = [Activity(), Activity()]
}

class Activity: Identifiable{
    var dateString: String = ""
    var beginTime: String = "10:00"
    var endTime: String = "12:00"
    var name: String = "Work"
    
    
    var weather: String = "Cloudy"
    var temp: String = "23"
    
    init() {
        let dateFormatter = DateFormatter()
        // Set the date format to YYYY-MM-DD
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // Convert the Date instance to a string with the desired format
        dateString = dateFormatter.string(from: Date.now)
    }
}
