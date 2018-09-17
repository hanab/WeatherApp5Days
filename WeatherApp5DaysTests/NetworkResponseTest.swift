//
//  NetworkResponseTest.swift
//  WeatherApp5DaysTests
//
//  Created by Hana  Demas on 9/17/18.
//  Copyright © 2018 ___HANADEMAS___. All rights reserved.
//

import XCTest
@testable import WeatherApp5Days

class NetworkResponseTest: XCTestCase {
    
    //MARK: Properties
    fileprivate var openWeatherMapGetway:OpenWeatherMapGetway!
    
    override func setUp() {
        super.setUp()
        openWeatherMapGetway = OpenWeatherMapGetway(session: URLSession.shared)
    }
    
    override func tearDown() {
        openWeatherMapGetway = nil
    }
    
    //MARK: TestCases
    func testAPIResponse() {
        let testExpectation =  expectation(description: "open weather response expectation")
        
        openWeatherMapGetway.fetchForcasts(for: "Munich,de", completion: {(result) in
            switch result {
            case let .Success(forcasts):
                XCTAssert(forcasts.count == 40, "more or less forcasts than expected \(forcasts.count)")
                testExpectation.fulfill()
            case let .Failure(error):
                print(error?.localizedDescription ?? "error")
            }
        })
        waitForExpectations(timeout: 10, handler: nil)
    }

    //test initalizer of the weatherforcast object
    func testForcastInitalizer() {
        let forcast = WeatherForcast(dateString: "2018-01-30", hourString: "18", temperature: 12, iconId: "10d")
        
        XCTAssertEqual(forcast.dateString, "2018-01-30", "The date string is not as expected")
        XCTAssertEqual(forcast.hourString, "18", "The hour string is not as expected")
        XCTAssertEqual(forcast.temperature, 12, "The temperature is not as expected")
        XCTAssertEqual(forcast.iconId, "10d", "The icon ID string is not as expected")
    }
}
