//
//  WeatherManager.swift
//  WeatherAPI
//
//  Created by yuteng Lan on 2024/5/11.
//

import Foundation
class WeatherManager: ObservableObject {
    @Published var weatherData: WeatherData?
    @Published var weatherDataShow: WeatherDataShow = WeatherDataShow()
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/forecast"
    let YourAPIKey = "da61cd6f11a0042368ac1a0871cb006d"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)?q=\(cityName)&appid=\(YourAPIKey)&units=metric"
        
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error)
                    return
                }
                if let safeData = data {
                    self.parseJSON(weatherData: safeData)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        do {
            print(weatherData)
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            DispatchQueue.main.async {
                self.weatherData = decodedData
                self.toWeatherDataShow()
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
}
