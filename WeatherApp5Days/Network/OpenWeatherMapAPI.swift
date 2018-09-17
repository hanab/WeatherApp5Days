//
//  OpenWeatherMapAPI.swift
//  WeatherApp5Days
//
//  Created by Hana  Demas on 9/13/18.
//  Copyright © 2018 ___HANADEMAS___. All rights reserved.
//

import Foundation

enum Method: String {
    case Get = "GET"
}

// OpenWeatherMap API response
enum WeatherResult {
    case Success([WeatherForcast])
    case Failure(Error?)
}

//errors when network request or parsing
enum WeatherResponseError: Error{
    case InvalidJSONData
    case NoData
    case InvalidFilePath
}

//get keys in info.plist file
struct InfoPListKey {
    static let openWeatherApiClientID = "OpenWeatherAPIKey"
}

// structure for generating the full url and parsing json
struct OpenWeatherMapAPI {
    
    //MARK: Properies
    fileprivate static let baseURLString = "https://api.openweathermap.org/data/2.5/forecast"
    
    //MARK: Methods
    fileprivate static func openWeatherMapForcastUrl(method: Method, cityAndCountryCode: String, parameters: [String:String]?) -> URL {
        
        // OpenWeatherAPI client ID
        guard let appID = Bundle.main.infoDictionary?[InfoPListKey.openWeatherApiClientID] as? String else {
            fatalError("Missing string value for \(InfoPListKey.openWeatherApiClientID) in the info.plist file.")
        }
        
        var components = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "method": method.rawValue,
            "appid": appID,
            "q": cityAndCountryCode
            
        ]
        
        for (key,value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters {
            for (key,value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        
        components.queryItems = queryItems
        return components.url!
    }
    
    //static function to get the weatherforcast url for a given city
    static func openWeatherMapForcastUrl(for city: String) -> URL {
        return openWeatherMapForcastUrl(method: Method.Get, cityAndCountryCode: city,  parameters: nil)
    }
    
    //Function to construct weatherforcast object
    private static func forcastFromJSONObject(json: [String : AnyObject]) -> WeatherForcast? {
        guard let main = json["main"] as? [String : AnyObject],
            let temp = main["temp"] as? Double,
            let weatherArray = json["weather"] as? [AnyObject], let weather = weatherArray[0] as? [String : AnyObject],
            let iconString = weather["icon"] as? String,
            let dateString = json["dt_txt"] as? String else {
                return nil
        }
        let tempCelicus = (temp - 273.15).roundedtoInt()
        let date = dateString.getDateFromString()
        let dateStringWithoutTime = date?.getDateStringFromDate() ?? ""
        let hourString = date?.gethourStringFromDate() ?? ""
        
        return WeatherForcast(dateString: dateStringWithoutTime, hourString: hourString, temperature: tempCelicus, iconId: iconString)
    }
    
    //Get all forcasts for 5 days with 3hrs interval from json
    static func weatherForcastsFromJSONData(data: Data?) -> WeatherResult {
        do {
            guard let data = data  else {
                return .Failure(WeatherResponseError.NoData)
            }
            let jsonObject: AnyObject = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
            
            guard let jsonObjectArray = jsonObject["list"] as? [[String : AnyObject]] else {
                return .Failure( WeatherResponseError.InvalidJSONData)
            }
            var allForcasts = [WeatherForcast]()
            
            for forcastJSON in jsonObjectArray {
                if let forcast = forcastFromJSONObject(json: forcastJSON) {
                    allForcasts.append(forcast)
                }
            }
            
            if allForcasts.isEmpty && !jsonObjectArray .isEmpty {
                return .Failure(WeatherResponseError.InvalidJSONData)
            }
            return .Success(allForcasts)
        }
        catch let error {
            return .Failure(error)
        }
    }
}
