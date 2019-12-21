//
//  WeatherData.swift
//  Clima
//
//  Created by Abhishek Sinha on 03/12/19.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let city: City
    let list: [List]
}

struct City: Codable {
    let name: String
}

struct List: Codable {
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
}
