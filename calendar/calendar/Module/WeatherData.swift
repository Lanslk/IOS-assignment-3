//
//  WeatherData.swift
//  WeatherAPI
//
//  Created by yuteng Lan on 2024/5/11.
//

import Foundation

struct WeatherData: Decodable {
    let list: [PeriodWeather]
}

struct PeriodWeather: Decodable {
    let weather: [Weather]
    let main: Main
    let dt: Double
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let main: String
    let description: String
}

struct WeatherDataShow {
    var weatherDict: [String : [String : [String : String]]] = [:]
}
