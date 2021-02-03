//
//  URL+Extensions.swift
//  Weather
//
//  Created by Luís Felipe Polo on 25/01/21.
//

import Foundation

extension URL {
    static func urlForWeatherAPI(city : String) -> URL? {
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?q=" + city + "&appid=9134f51446beffa5d08705572b25c543&units=metric")
    }
}
