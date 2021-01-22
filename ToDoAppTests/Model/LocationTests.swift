//
//  LocationTests.swift
//  ToDoAppTests
//
//  Created by Denis Larin on 18.01.2021.
//

import XCTest
import CoreLocation
@testable import ToDoApp

class LocationTests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }
    
    func testInitSetsName () {
        let location = Location(name: "Foo")
        XCTAssertEqual(location.name, "Foo")
    }
    // тест метода получения координат
    func testInitSetsCoordinates () {
        let coordinate = CLLocationCoordinate2D(
            latitude: 1, longitude: 2)
    
    let location = Location(name: "Foo", coordinate: coordinate)
    XCTAssertEqual(location.coordinate?.latitude, coordinate.latitude)
    XCTAssertEqual(location.coordinate?.longitude, coordinate.longitude)
    }
}
