//
//  TestCalcuationAndConversions.swift
//  WeatherApp5DaysTests
//
//  Created by Hana  Demas on 9/17/18.
//  Copyright © 2018 ___HANADEMAS___. All rights reserved.
//

import XCTest
@testable import WeatherApp5Days

class TestCalcuationAndConversions: XCTestCase {
    
    //MARK: TestCases
    func testRoundingDoubleToNearestInt() {
        let temperature = 25.4567
        XCTAssertEqual(temperature.roundedtoInt(), 25)
        let temproundHigher = 30.945
        XCTAssertEqual(temproundHigher.roundedtoInt(), 31)
    }
}
