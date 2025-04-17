//
//  weatherModel.swift
//  SimpleWeather
//
//  Created by Bence Családi on 2025. 04. 17..
//


import Foundation

struct WeatherResponse: Codable {
    let main: Main
    let weather: [Weather]
    let dt: TimeInterval
}

struct Main: Codable {
    let temp_min: Double
    let temp_max: Double
}

struct Weather: Codable {
    let main: String
}
