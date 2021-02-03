//
//  WeatherResult.swift
//  Weather
//
//  Created by Luís Felipe Polo on 25/01/21.
//

import Foundation

struct WeatherResult : Decodable {
    let main : Weather
}

extension WeatherResult {
    static var empty : WeatherResult {
        return WeatherResult(main: Weather(temp: 0, humidity: 0))
    }
}

struct Weather : Decodable {
    let temp : Double
    let humidity : Double
}
