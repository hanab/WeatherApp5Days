//
//  Extensions.swift
//  WeatherApp5Days
//
//  Created by Hana  Demas on 9/13/18.
//  Copyright © 2018 ___HANADEMAS___. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Rounds the double to the higest intiger
extension Double {
    func roundedtoInt() -> Int {
        return Int((self.rounded()))
    }
}

// MARK: - converting string into date
extension String {
    
    func getDateFromString() ->Date? {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormat.date(from: self)
    }
}

// MARK: - converting date into date and time string
extension Date {
    
    func getDateStringFromDate() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        return dateFormat.string(from: self)
    }
    
    func gethourStringFromDate() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "HH"
        return dateFormat.string(from: self)
    }
}

// MARK: - seuence extention used to group arrays of forcast by date(day of the week)
public extension Sequence {
    
    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        var categories: [U: [Iterator.Element]] = [:]
        
        for element in self {
            let key = key(element)
            if case nil = categories[key]?.append(element) {
                categories[key] = [element]
            }
        }
        return categories
    }
}

