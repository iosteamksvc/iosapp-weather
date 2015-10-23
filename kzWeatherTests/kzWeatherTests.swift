//
//  kzWeatherTests.swift
//  kzWeatherTests
//
//  Created by Vinh Hua on 10/14/15.
//  Copyright © 2015 iosteamksvc. All rights reserved.
//
import UIKit
import XCTest

class kzWeatherTests: XCTestCase {
    
    // MARK: hzWeather Tests
    // Tests to confirm that the Meal initializer returns when no name or a negative rating is provided.
    func testFavoritePlaceInitialization() {
        
        // Success case.
        let potentialItem = FavoritePlace(name: "Place Test 1")
        XCTAssertNotNil(potentialItem)
        
        // Failure case.
        let noName = FavoritePlace(name: "")
        XCTAssertNil(noName)
    }
    
}
