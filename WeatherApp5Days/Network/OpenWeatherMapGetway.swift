//
//  OpenWeatherMapGetway.swift
//  WeatherApp5Days
//
//  Created by Hana  Demas on 9/13/18.
//  Copyright © 2018 ___HANADEMAS___. All rights reserved.
//

import Foundation

class OpenWeatherMapGetway {
    
    //MARK: Properties
    private let session: NetworkSessionProtocol
    
    //MARK: Init
    init(session: NetworkSessionProtocol) {
        self.session = session
    }
    
    //MARK: Functions
    func fetchForcasts(url: URL, completion: @escaping (_ forcasts: WeatherResult) -> ()) {
        let request = URLRequest(url: url)
        let task = session.sessionDataTask(with: request, completionHandler:  { (data, response, error) -> Void in
            let results = self.processOpenWeatherMapForcastRequest(data: data, error: error)
            completion(results)
        })
        task.resume()
    }
    
    //Get all forcasts for 5 days
    fileprivate func processOpenWeatherMapForcastRequest(data: Data?, error: Error?) -> WeatherResult {
        guard data != nil else {
            return .Failure(error)
        }
        return OpenWeatherMapAPI.weatherForcastsFromJSONData(data: data)
    }
    
    //Get all forcasts for a given city
    func fetchForcasts(for city: String, completion: @escaping (_ forcasts: WeatherResult) -> ()) {
        let url = OpenWeatherMapAPI.openWeatherMapForcastUrl(for: city)
        fetchForcasts(url: url, completion: completion)
    }
}
