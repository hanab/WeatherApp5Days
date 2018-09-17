//
//  JsonMappingTest.swift
//  WeatherApp5DaysTests
//
//  Created by Hana  Demas on 9/16/18.
//  Copyright © 2018 ___HANADEMAS___. All rights reserved.
//

import XCTest
@testable import WeatherApp5Days

class JsonMappingTest: XCTestCase {
    
    //MARK: Properties
    var viewModel:WeatherForcastViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = WeatherForcastViewModel()
    }
    
    //MARK: TestCases
    func testJsonMappingFromFileInBundle() {
        
        viewModel.getAllOfflineForcasts {
            self.viewModel.organizeForcasts()
        }
        
        XCTAssertEqual(viewModel.getNumberOfDays(), 6)
        
        XCTAssertEqual(viewModel.getDayAtIndex(index: 0), "2017-01-30")
        XCTAssertEqual(viewModel.getDayAtIndex(index: 1), "2017-01-31")
        XCTAssertEqual(viewModel.getDayAtIndex(index: 2), "2017-02-01")
        XCTAssertEqual(viewModel.getDayAtIndex(index: 3), "2017-02-02")
        XCTAssertEqual(viewModel.getDayAtIndex(index: 4), "2017-02-03")
        XCTAssertEqual(viewModel.getDayAtIndex(index: 5), "2017-02-04")

        XCTAssertEqual(viewModel.getNumberOfForcasts(day:  "2017-01-30"), 2)
        XCTAssertEqual(viewModel.getNumberOfForcasts(day:  "2017-01-31"), 8)
        XCTAssertEqual(viewModel.getNumberOfForcasts(day:  "2017-02-01"), 8)
        XCTAssertEqual(viewModel.getNumberOfForcasts(day:  "2017-02-02"), 8)
        XCTAssertEqual(viewModel.getNumberOfForcasts(day:  "2017-02-03"), 8)
        XCTAssertEqual(viewModel.getNumberOfForcasts(day:  "2017-02-04"), 6)
        
        //one sample forcast test
        XCTAssertEqual(viewModel.getForcastAtIndex(day: "2017-01-30", index: 0)?.hourString, "18")
        XCTAssertEqual(viewModel.getForcastAtIndex(day: "2017-01-30", index: 0)?.temperature, 11)
    }
}
