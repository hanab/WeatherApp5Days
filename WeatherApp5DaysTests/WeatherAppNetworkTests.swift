//
//  WeatherApp5DaysTests.swift
//  WeatherApp5DaysTests
//
//  Created by Hana  Demas on 9/13/18.
//  Copyright © 2018 ___HANADEMAS___. All rights reserved.
//

import XCTest
@testable import WeatherApp5Days

class WeatherAppNetworkTests: XCTestCase {
    
    //MARK: Properties
    var openWeatherMapGetway:OpenWeatherMapGetway!
    var session = MockURLSession()
    
    override func setUp() {
        super.setUp()
        openWeatherMapGetway = OpenWeatherMapGetway(session: session)
    }
    
    //MARK: TestCases
    func testDataTaskResumeCalled() {
        let dataTask = MockURLSessionDataTask()
        session.mockDataTask = dataTask
        
        openWeatherMapGetway.fetchForcasts(for: "Munich,de",  completion: {(result) in
            //nothing to do with the results for this test
        })
        XCTAssert(dataTask.resumeWasCalled)
    }
    
    func testDataTaskReturnPhotos() {
        let dataTask = MockURLSessionDataTask()
        session.mockDataTask = dataTask
        
        guard let url = URL(string: "https://myurl") else {
            fatalError("URL can't be empty")
        }
        
        openWeatherMapGetway.fetchForcasts(url: url, completion: {(result) in
            //nothing to do with the results for this test
        })
        XCTAssert((session.mockURL == url))
    }
    
    func testSuccessfullResponse() {
        let data = "{}".data(using: .utf8)
        session.mockData = data

        let url = URL(fileURLWithPath: "url")
        var actualData: WeatherResult?

        openWeatherMapGetway.fetchForcasts(url: url, completion: {(result) in
            actualData = result
        })

        XCTAssertNotNil(actualData)
    }
}
