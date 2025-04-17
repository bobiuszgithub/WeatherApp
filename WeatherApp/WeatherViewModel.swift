//
//  WeatherViewModel.swift
//  SimpleWeather
//
//  Created by Bence Családi on 2025. 04. 17..
//

import Foundation

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var high: Int = 0
    @Published var low: Int = 0
    @Published var condition: String = ""
    @Published var day: String = ""
    @Published var cityName: String = ""

    func fetchWeather(for city: String) async {
        let apiKey = Hidden.openWeatherAPIKey
        print("Using API key: \(apiKey)")
        let cityEscaped = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?q=\(cityEscaped)&appid=\(apiKey)&units=metric"
        print("Fetching from URL: \(urlStr)")

        guard let url = URL(string: urlStr) else {
            print("Invalid URL")
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status code: \(httpResponse.statusCode)")
            }

            let decoded = try JSONDecoder().decode(WeatherResponse.self, from: data)
            print("Decoded response: \(decoded)")

            self.high = Int(decoded.main.temp_max)
            self.low = Int(decoded.main.temp_min)
            self.condition = decoded.weather.first?.main ?? ""
            self.day = Self.getWeekday(from: decoded.dt)
            self.cityName = city

        } catch {
            print("❌ Error fetching weather: \(error.localizedDescription)")
        }
    }


    private static func getWeekday(from timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
}
