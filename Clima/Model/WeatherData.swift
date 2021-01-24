//
//  WeatherData.swift
//  Clima
//
//  Created by Illya Sirosh on 17.08.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [WeatherItem]
    let dt: Int
    let timezone: Int
}

struct Main: Decodable {
    let temp: Double
}

struct WeatherItem: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
