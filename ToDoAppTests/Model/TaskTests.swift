//
//  TaskTests.swift
//  ToDoAppTests
//
//  Created by Denis Larin on 18.01.2021.
//

import XCTest
@testable import ToDoApp

class TaskTests: XCTestCase {
    // 1 метод - проверка на то что мы можем инициализировать task при помощи заголовка
    func testInitTaskWithTitle() {
        let task = Task(title: "Foo") // Foo Bar Baz - placeholder - заглушка
        XCTAssertNotNil(task)
    }
    // можем ли мы создать task при помощи заголовка и описания
    func testInitTaskWithTitleAndDescription() {
        let task = Task(title: "Foo", description: "Bar") // Foo Bar Baz - placeholder - заглушка
        XCTAssertNotNil(task)
    }
    // когда дан заголовок мы его устанавливаем
    func testWhenGivenTitleSetsTitle () {
        let task = Task(title: "Foo")
        XCTAssertEqual(task.title, "Foo")
    }
    // когда дано описание мы его устанавливаем
    func testWhenGivenDescriptionSetsDescription () {
        let task = Task(title: "Foo", description: "Bar")
        XCTAssertTrue(task.description == "Bar")
    }
    // тест что у нашего task будет date
    func testTaskInitWithDate() {
        let task = Task(title:"Foo")
        XCTAssertNotNil(task.date)
    }
    //
    func testWhenGivenLocationSetsDescription () {
        let location = Location(name: "Foo")
        
        let task = Task(title: "Bar", description: "Baz", location: location)
        XCTAssertEqual(location, task.location)
    }
    
}
