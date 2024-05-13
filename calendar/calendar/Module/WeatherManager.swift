//
//  WeatherManager.swift
//  WeatherAPI
//
//  Created by yuteng Lan on 2024/5/11.
//

import Foundation
class WeatherManager: ObservableObject {
    var weatherData: WeatherData?
    var weatherDataShow: WeatherDataShow = WeatherDataShow()
    
    @Published var weather: String = ""
    @Published var temp: String = ""
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/forecast"
    let YourAPIKey = "da61cd6f11a0042368ac1a0871cb006d"
    
    func fetchWeather(cityName: String, date: Date, time: Date, completion: @escaping (Bool) -> Void) {
        let urlString = "\(weatherURL)?q=\(cityName)&appid=\(YourAPIKey)&units=metric"
        // convert to time and date String
        //Create a DateFormatter instance
        let dateFormatter = DateFormatter()
        // Set the date format to YYYY:MM:DD
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        // Set the time format to HH:mm
        dateFormatter.dateFormat = "HH:mm"
        let timeString = dateFormatter.string(from: time)
        
        print("\(cityName) \(dateString) \(timeString)")
        
        performRequest(urlString: urlString, date: dateString, time: timeString, completion: completion)
    }
    
    func performRequest(urlString: String, date: String, time: String, completion: @escaping (Bool) -> Void) {
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
                    self.getWeather(date: date, time: time, completion: completion)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            DispatchQueue.main.async {
                self.weatherData = decodedData
            }
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
                
                let weatherMap = ["temp": String(format: "%.f", eachData.main.temp), "main": eachData.weather[0].main, "description": eachData.weather[0].description] as [String : String]
                
                if var timeWeather = weatherDataShow.weatherDict[dateString] {
                    timeWeather[timeString] = weatherMap
                    weatherDataShow.weatherDict[dateString] = timeWeather
                } else {
                    weatherDataShow.weatherDict[dateString] = [timeString: weatherMap]
                }
            }
        }
    }
    
    func getWeather(date: String, time: String, completion: @escaping (Bool) -> Void) {
        if let timeWeather = weatherDataShow.weatherDict[date]?.sorted(by: {$0.key < $1.key }) {
            for (key, value) in timeWeather {
                if (key >= time) {
                    DispatchQueue.main.async {
                        self.weather = value["description"] ?? ""
                        self.temp = value["temp"] ?? ""
                        completion(true)
                    }
                    print("\(key): \(value)")
                    return
                }
                
            }
            DispatchQueue.main.async {
                completion(true)
            }
        } else {
            DispatchQueue.main.async {
                completion(false) // If weather data for the specified date is not found, indicate failure
            }
        }
    }
}
