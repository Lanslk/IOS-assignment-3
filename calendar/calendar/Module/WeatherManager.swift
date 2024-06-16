//
//  WeatherManager.swift
//  WeatherAPI
//
//  Created by yuteng Lan on 2024/5/11.
//

import Foundation
import CoreLocation
import SwiftUI

class WeatherManager: ObservableObject {
    var weatherData: WeatherData?
    var weatherDataShow: WeatherDataShow = WeatherDataShow()
    
    @Published var weather: String = ""
    @Published var temp: String = ""
    @Published var country: String = ""
    @Published var city: String = ""
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/forecast"
    let YourAPIKey = "69be889a06af3b0f74fafe3a7c69dbce"
    // fetch weather via weather API
    func fetchWeather(isCurrentLocation: Bool, country: String, cityName: String, date: Date, beginTime: Date, endTime: Date, completion: @escaping (Bool) -> Void) {
	        var urlString = "\(weatherURL)?"
        weatherDataShow = WeatherDataShow()
        var parameter = ""
        if (isCurrentLocation) {
            // get current location
            let locationManager = LocationManager()
            let CLLocation = locationManager.requestLocation { location in
                if location != nil {
                    completion(true)
                } else {
                    completion(false)
                }
            }
            parameter = "lat=" + String(CLLocation.coordinate.latitude) + "&lon=" + String(CLLocation.coordinate.longitude)
        } else {
            parameter = "q=" + cityName + "," + country
        }
        
        urlString += parameter
        urlString += "&appid=\(YourAPIKey)&units=metric"
        // convert to time and date String
        //Create a DateFormatter instance
        let dateFormatter = DateFormatter()
        // Set the date format to YYYY:MM:DD
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var dateString = dateFormatter.string(from: date)
        // Set the time format to HH:mm
        dateFormatter.dateFormat = "HH:mm"
        var timeString = dateFormatter.string(from: beginTime)
        if timeString > "22:00" {
            timeString = "22:00"
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if dateString == dateFormatter.string(from: Date.now) {
                dateString = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 1, to: date) ?? Date.now)
                timeString = "01:00"
            }
        }
        
        let endTimeString = dateFormatter.string(from: endTime)
        print("\(urlString) \(dateString) \(timeString)")
        
        performRequest(urlString: urlString, date: dateString, beginTime: timeString, endTime: endTimeString, completion: completion)
    }
    
    func performRequest(urlString: String, date: String, beginTime: String, endTime: String, completion: @escaping (Bool) -> Void) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error)
                    completion(false)
                    return
                }
                if let safeData = data {
                    self.parseJSON(weatherData: safeData)
                    self.toWeatherDataShow()
                    self.getWeather(date: date, beginTime: beginTime, endTime: endTime, completion: completion)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            self.weatherData = decodedData
        } catch {
            print(error)
        }
    }
    
    func toWeatherDataShow() {
        if let weatherData = weatherData {
            for eachData in weatherData.list {
                // Create a DateFormatter instance
                let dateFormatter = DateFormatter()
                // Set the date format to YYYY-MM-DD
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                // Convert the Date instance to a string with the desired format
                let dateString = dateFormatter.string(from: Date(timeIntervalSince1970: eachData.dt))
                dateFormatter.dateFormat = "HH:mm"
                let timeString = dateFormatter.string(from: Date(timeIntervalSince1970: eachData.dt))
                
                let weatherMap = ["temp": String(format: "%.f", eachData.main.temp), "main": eachData.weather[0].main, "description": eachData.weather[0].description, "country": weatherData.city.country, "city": weatherData.city.name] as [String : String]
                
                if var timeWeather = weatherDataShow.weatherDict[dateString] {
                    timeWeather[timeString] = weatherMap
                    weatherDataShow.weatherDict[dateString] = timeWeather
                } else {
                    weatherDataShow.weatherDict[dateString] = [timeString: weatherMap]
                }
            }
        }
    }
    
    func getWeather(date: String, beginTime: String, endTime: String, completion: @escaping (Bool) -> Void) {
        if let timeWeather = weatherDataShow.weatherDict[date] {
            let times = ["01:00", "04:00", "07:00", "10:00", "13:00", "16:00", "19:00", "22:00"]
            let beginWeatherTime = closestTime(targetTime: beginTime)
            let endWeatherTime = closestTime(targetTime: endTime)
            
            var beginWeather = ""
            var endWeather = ""
            var highTemp = ""
            var lowTemp = ""
            
            guard let beginMinutes = minutesSinceMidnight(time: beginWeatherTime),
                  let endMinutes = minutesSinceMidnight(time: endWeatherTime) else {
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            
            for time in times {
                guard let timeMinutes = minutesSinceMidnight(time: time) else { continue }
                if timeMinutes >= beginMinutes && timeMinutes <= endMinutes, let value = timeWeather[time] {
                    if beginWeather.isEmpty {
                        beginWeather = value["description"] ?? ""
                    }
                    endWeather = value["description"] ?? ""
                    
                    if highTemp.isEmpty {
                        highTemp = value["temp"] ?? ""
                        lowTemp = value["temp"] ?? ""
                    }
                    
                    if highTemp < value["temp"] ?? "" {
                        highTemp = value["temp"] ?? ""
                    }
                    
                    if lowTemp > value["temp"] ?? "" {
                        lowTemp = value["temp"] ?? ""
                    }
                    
                    DispatchQueue.main.async {
                        self.country = value["country"] ?? ""
                        self.city = value["city"] ?? ""
                    }
                    print("weather:\(time): \(value)")
                }
            }
            
            DispatchQueue.main.async {
                if (beginWeather != endWeather) {
                    self.weather = beginWeather + " to " + endWeather
                } else {
                    self.weather = beginWeather
                }
                
                if (lowTemp != highTemp) {
                    self.temp = lowTemp + " to " + highTemp
                } else {
                    self.temp = lowTemp
                }
                completion(true)
            }
        } else {
            DispatchQueue.main.async {
                completion(false) // If weather data for the specified date is not found, indicate failure
            }
        }
    }
    
    func minutesSinceMidnight(time: String) -> Int? {
        let components = time.split(separator: ":").compactMap { Int($0) }
        guard components.count == 2 else { return nil }
        return components[0] * 60 + components[1]
    }

    func closestTime(targetTime: String) -> String {
        let times = ["01:00", "04:00", "07:00", "10:00", "13:00", "16:00", "19:00", "22:00"]
        guard let targetMinutes = minutesSinceMidnight(time: targetTime) else { return "" }
        
        var closestTime: String = ""
        var smallestDifference = Int.max
        
        for time in times {
            if let timeMinutes = minutesSinceMidnight(time: time) {
                let difference = abs(timeMinutes - targetMinutes)
                if difference < smallestDifference {
                    smallestDifference = difference
                    closestTime = time
                }
            }
        }
        
        return closestTime
    }
}
