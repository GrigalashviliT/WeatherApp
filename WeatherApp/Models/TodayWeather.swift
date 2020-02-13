//
//  TodayWeather.swift
//  WeatherApp
//
//  Created by Tornike Grigalashvili on 2/12/20.
//  Copyright © 2020 Tornike Grigalashvili. All rights reserved.
//

struct TodayWeather: Codable {
    let cod: Int
    let visibility: Int
    let sys: Sys
    let dt: Int
    let name: String
    let main: Main
    let timezone: Int
    let coord: Coord
    let id: Int
    let clouds: Clouds
    let base: String
    let wind: Wind
    let weather: [Weather]
}

struct Sys: Codable {
    let country: String
    let id: Int
    let sunrise: UInt64
    let sunset: UInt64
    let type: Int
}

struct Main: Codable {
    let feelsLike: Double
    let humidity: Int
    let pressure: Int
    let temp: Double
    let tempMax: Double
    let tempMin: Double
    private enum CodingKeys: String, CodingKey {
        case feelsLike = "feels_like", humidity, pressure, temp, tempMax = "temp_max", tempMin = "temp_min"
    }
}

struct Coord: Codable {
    let lat: Double
    let lon: Double
}

struct Clouds: Codable {
    let all: Int
}

struct Wind: Codable {
    let deg: Int
    let speed: Double
}

struct Weather: Codable {
    let description: String
    let icon: String
    let id: Int
    let main: String
}
