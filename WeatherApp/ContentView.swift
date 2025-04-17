//
//  ContentView.swift
//  WeatherToday
//
//  Created by You on 2025. 04. 17.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = WeatherViewModel()

    var body: some View {
        VStack(spacing: 20) {
            if viewModel.day != "" {
                // Show city name
                Text(viewModel.cityName)
                    .font(.largeTitle)
                    .bold()

                // Apple-style weather card
                DayForecast(day: viewModel.day,
                            condition: viewModel.condition,
                            high: viewModel.high,
                            low: viewModel.low)
            } else {
                ProgressView("Loading weather...")
                    .padding()
            }
        }
        .task {
            await viewModel.fetchWeather(for: "Budapest") // Replace with your city if needed
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

struct DayForecast: View {
    let day: String
    let condition: String
    let high: Int
    let low: Int

    var iconName: String {
        switch condition.lowercased() {
        case "rain":
            return "cloud.rain.fill"
        case "clouds":
            return "cloud.fill"
        case "clear":
            return "sun.max.fill"
        case "snow":
            return "snowflake"
        case "thunderstorm":
            return "cloud.bolt.rain.fill"
        case "drizzle":
            return "cloud.drizzle.fill"
        case "fog", "mist", "haze", "smoke":
            return "cloud.fog.fill"
        default:
            return "questionmark.circle"
        }
    }

    var iconColor: Color {
        switch condition.lowercased() {
        case "clear":
            return .yellow
        case "rain", "drizzle", "thunderstorm":
            return .blue
        case "clouds":
            return .gray
        case "snow":
            return .cyan
        default:
            return .secondary
        }
    }

    var body: some View {
        VStack {
            Text(day)
                .font(.title2)
                .fontWeight(.medium)

            Image(systemName: iconName)
                .foregroundStyle(iconColor)
                .font(.system(size: 60))
                .padding(8)

            Text(condition.capitalized)
                .font(.subheadline)
                .foregroundStyle(.primary)

            Text("High: \(high)°C")
                .font(.headline)

            Text("Low: \(low)°C")
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 3)
    }
}
