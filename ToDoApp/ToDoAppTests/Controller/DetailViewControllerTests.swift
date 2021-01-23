//
//  DetailViewControllerTests.swift
//  ToDoAppTests
//
//  Created by Denis Larin on 21.01.2021.
//

import XCTest
import CoreLocation
@testable import ToDoApp

class DetailViewControllerTests: XCTestCase {
    var sut: DetailViewController!

    override func setUpWithError() throws {
        super.setUp()
        // рефакторинг
        let storyboard = UIStoryboard(name: "Main", bundle:  nil)
        sut = storyboard.instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController
        
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        
    }
    
    func test_Has_TitleLabel() {
//        let storyboard = UIStoryboard(name: "Main", bundle:  nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as! DetailViewController
//
//        controller.loadViewIfNeeded()
        
        XCTAssertNotNil(sut.titleLabel)
        
        XCTAssertTrue(sut.titleLabel.isDescendant(of: sut.view))
    }
    func test_Has_DescriptionLabel() {
//        let storyboard = UIStoryboard(name: "Main", bundle:  nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as! DetailViewController
//
//        controller.loadViewIfNeeded()
        
        XCTAssertNotNil(sut.descriptionLabel)
        XCTAssertTrue(sut.descriptionLabel.isDescendant(of: sut.view))
    }
    
    func test_Has_DateLabel() {
        
        XCTAssertNotNil(sut.dateLabel)
        XCTAssertTrue(sut.dateLabel.isDescendant(of: sut.view))
    }
    
    func test_Has_LocationLabel() {
        
        XCTAssertNotNil(sut.locationLabel)
        XCTAssertTrue(sut.locationLabel.isDescendant(of: sut.view))
    }
    
    func test_Has_MapView() {
        
        XCTAssertNotNil(sut.mapView)
        XCTAssertTrue(sut.mapView.isDescendant(of: sut.view))
    }
    // рефакторим
    func setupTaskAndAppearanceTransition() {
        let coordinate = CLLocationCoordinate2D(latitude: 55.75407597, longitude: 37.62038151)
        let location = Location(name: "Baz", coordinate: coordinate)
        let date = Date(timeIntervalSince1970: 1546300800)
        let task = Task(title: "Foo", description: "Bar",date: date, location: location)
        sut.task = task
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
    }
    
    func test_SettingTask_Sets_TitleLabel() {
        
//        let coordinate = CLLocationCoordinate2D(latitude: 55.75407597, longitude: 37.62038151)
//        let location = Location(name: "Baz", coordinate: coordinate)
//        let date = Date(timeIntervalSince1970: 1546300800)
//        let task = Task(title: "Foo", description: "Bar",date: date, location: location)
//        sut.task = task
//        sut.beginAppearanceTransition(true, animated: true)
//        sut.endAppearanceTransition()
        setupTaskAndAppearanceTransition()
        
        XCTAssertEqual(sut.titleLabel.text, "Foo")
    }
    
    func test_SettingTask_Sets_DescriptionLabel() {
        
//        let coordinate = CLLocationCoordinate2D(latitude: 55.75407597, longitude: 37.62038151)
//        let location = Location(name: "Baz", coordinate: coordinate)
//        let date = Date(timeIntervalSince1970: 1546300800)
//        let task = Task(title: "Foo", description: "Bar",date: date, location: location)
//        sut.task = task
//        sut.beginAppearanceTransition(true, animated: true)
//        sut.endAppearanceTransition()
        setupTaskAndAppearanceTransition()
        
        XCTAssertEqual(sut.descriptionLabel.text, "Bar")
    }
    func test_SettingTask_Sets_LocationLabel() {
        
        setupTaskAndAppearanceTransition()
        
        XCTAssertEqual(sut.locationLabel.text, "Baz")
    }
    
    func test_SettingTask_Sets_DateLabel() {
        
        setupTaskAndAppearanceTransition()
        
        XCTAssertEqual(sut.dateLabel.text, "01.01.19")
    }
    
    func test_SettingTask_Sets_MapView() {
        
        setupTaskAndAppearanceTransition()
        
        XCTAssertEqual(sut.mapView.centerCoordinate.latitude, 55.75407597, accuracy: 0.001)
        XCTAssertEqual(sut.mapView.centerCoordinate.longitude, 37.62038151, accuracy: 0.001)
    }
}
