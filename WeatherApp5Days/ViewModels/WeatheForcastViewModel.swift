//
//  WeatheForcastViewModel.swift
//  WeatherApp5Days
//
//  Created by Hana  Demas on 9/14/18.
//  Copyright © 2018 ___HANADEMAS___. All rights reserved.
//

import Foundation

class WeatherForcastViewModel {
    
    //MARK: Properties
    fileprivate var apiDelegate = OpenWeatherMapGetway(session: URLSession.shared)
    //properties for storing and grouping network respose
    fileprivate var forcasts = [WeatherForcast]()
    fileprivate var availableDays: [String] = [String]()
    fileprivate var forcastByDate: [String: [WeatherForcast]] = [String: [WeatherForcast]]()
    
    //MARK: Functions
    func getAllForcastsFromAPI(for city: String, completion: (() -> ())? ) {
        //reset respose when switching between offline and online
        resetForcast()
        
        apiDelegate.fetchForcasts(for: city, completion: { (result) in
            switch result {
            case let .Success(forcasts):
                self.forcasts = forcasts
            case let .Failure(error):
                if let error = error {
                    print(error.localizedDescription)
                }
            }
            completion?()
        })
    }
    
    func getAllOfflineForcasts(completion: (() -> ())? ) {
        resetForcast()
        
        let forcasts = WeatherForcast.getForcastFromBundle()
        switch forcasts {
        case let .Success(forcastOffline):
            self.forcasts = forcastOffline
        case let .Failure(error):
            if let error = error {
                print(error.localizedDescription)
            }
        }
        completion?()
    }
    
    fileprivate func resetForcast() {
        self.forcasts.removeAll()
        self.availableDays.removeAll()
        self.forcastByDate.removeAll()
    }
    
    //MARK: Function to prepare data for UI
    //group forcasts by a singele date
    func organizeForcasts () {
        self.forcastByDate = self.forcasts.group {$0.dateString}
        
        for forcast in self.forcastByDate {
            self.availableDays.append(forcast.key)
        }
        
        if self.availableDays.count > 1 {
            self.availableDays.sort()
        }
    }
    
    func getNumberOfDays() ->Int {
        return self.availableDays.count
    }
    
    func getDayAtIndex(index:Int) ->String {
        guard index < self.availableDays.count else {
            return ""
        }
        return self.availableDays[index]
    }
    
    //get number of forcasts for a given day
    func getNumberOfForcasts(day:String)->Int {
        var count: Int = 0
        
        if let forcast = self.forcastByDate[day] {
            count = forcast.count
        }
        return count
    }
    
    func getForcastAtIndex(day:String, index:Int) -> WeatherForcast? {
        if let forcast = forcastByDate[day], index < forcast.count {
            return forcast[index]
        }
        return nil
    }
}
