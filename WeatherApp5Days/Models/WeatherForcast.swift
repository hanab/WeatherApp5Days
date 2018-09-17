//
//  WeatherForcast.swift
//  WeatherApp5Days
//
//  Created by Hana  Demas on 9/13/18.
//  Copyright © 2018 ___HANADEMAS___. All rights reserved.
//

import Foundation

struct WeatherForcast {
    
    //MARK: Properties
    var dateString: String
    var hourString: String
    var temperature: Int
    var iconId: String
    
    //MARK:Functions
    func iconImageUrl() -> String? {
        return  "https://openweathermap.org/img/w/" + iconId + ".png"
    }
}

extension WeatherForcast {
    
    static func getForcastFromBundle() -> WeatherResult {
        if let path = Bundle.main.path(forResource: "weatherOffline", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return OpenWeatherMapAPI.weatherForcastsFromJSONData(data: data)
            } catch  {
                return .Failure(WeatherResponseError.NoData)
            }
        }
        return .Failure(WeatherResponseError.InvalidFilePath)
    }
}
