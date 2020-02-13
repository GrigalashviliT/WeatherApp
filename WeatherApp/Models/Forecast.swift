//
//  Forecast.swift
//  WeatherApp
//
//  Created by Tornike Grigalashvili on 2/13/20.
//  Copyright © 2020 Tornike Grigalashvili. All rights reserved.
//

struct Forecast: Codable {
    let cod: String
    let message: Int
    let city: City
    let cnt: Int
    let list: [Forecasts]
}

struct City: Codable {
    let coord: Coord
    let country: String
    let id: Int
    let name: String
    let population: Int
    let sunrise: Int
    let sunset: Int
    let timezone: Int
}

struct Forecasts: Codable {
    let clouds: Clouds
    let dt: Int
    let dtTxt: String
    let main: Main
    let sys: Sys1
    let weather: [Weather]
    let wind: Wind
    
    private enum CodingKeys: String, CodingKey {
        case clouds, dt, dtTxt = "dt_txt", main, sys, weather, wind
    }
}

struct Sys1: Codable {
    let pod: String
}
