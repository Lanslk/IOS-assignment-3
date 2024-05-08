//
//  ContentViewModel.swift
//  calendar
//
//  Created by yuteng Lan on 2024/5/8.
//

import Foundation

class ContentViewModel: ObservableObject {
    
    @Published var year: String = ""
    @Published var month: String = ""
    @Published var day: Int = 0
    @Published var date: Date = Date.now
    
    @Published var weekday: String = ""
    @Published var sevenDay: [Int] = Array(repeating: 0, count: 7)
    
    @Published var dayIndex: Int = 0
    
    var montDict : [String:Int] = ["Jan": 1, "Feb": 2, "Mar": 3, "Apr": 4, "May": 5, "Jun": 6, "Jul": 7, "Aug": 8, "Sep": 9, "Oct": 10, "Nov": 11, "Dec": 12]
    
    var dayDict : [String:Int] = ["Mon": 0, "Tue": 1, "Wed": 2, "Thu": 3, "Fri": 4, "Sat": 5, "Sun": 6]
    
    @Published var dateString: String = ""
    
    func renewCalendar(newDate: Date) {
        
        // Create a DateFormatter instance
        let dateFormatter = DateFormatter()
        // Set the date format to YYYY-MM-DD
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // Convert the Date instance to a string with the desired format
        dateString = dateFormatter.string(from: newDate)
        
        date = newDate
        year = date.formatted(.dateTime.year())
        month = date.formatted(.dateTime.month())
        day = Int(date.formatted(.dateTime.day()))!
        weekday = date.formatted(.dateTime.weekday())
        
        getSevenDay()
    }
    
    func getSevenDay() {
        let numDays = getNumOfDays(year: Int(year)!, month: montDict[month]!)
        
        dayIndex = dayDict[weekday]!
        sevenDay[dayIndex] = day
        
        for index in 0...6 {
            let eachDay = day - (dayIndex - index)
            if (eachDay < 1) {
                sevenDay[index] = eachDay + getNumOfDays(year: Int(year)!, month: montDict[month]! - 1)
            } else if (eachDay > numDays) {
                sevenDay[index] = eachDay - getNumOfDays(year: Int(year)!, month: montDict[month]!)
            } else {
                sevenDay[index] = eachDay
            }
        }
    }
    
    func getNumOfDays(year :Int, month :Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        return numDays
    }
    
    func addDay(days :Int) {
        if let date = Calendar.current.date(byAdding: .day, value: days, to: date) {
            self.date = date
            renewCalendar(newDate: date)
        }
        
    }
}
