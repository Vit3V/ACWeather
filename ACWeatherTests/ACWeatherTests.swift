//
//  ACWeatherTests.swift
//  ACWeatherTests
//
//  Created by Vitalijs Vasilevskis on 14/10/2020.
//

import XCTest
import MapKit
@testable import ACWeather

class ACWeatherTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testOpenWeatherAPI() throws {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "Open Weather API Key") as? String else {
            XCTAssert(false)
            return
        }
        let api = OpenWeatherAPI(key: key, type: .json)
        let coord = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        var isRunning = true
        api.weather(location: coord, success: { response in
            print(response)
            XCTAssert(true)
            isRunning = false
        }, failure: {
            XCTAssert(false)
        })
        while (isRunning) {
            sleep(1)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
