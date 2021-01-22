//
//  TaskListViewControllerTests.swift
//  ToDoAppTests
//
//  Created by Denis Larin on 19.01.2021.
//

import XCTest
@testable import ToDoApp


class TaskListViewControllerTests: XCTestCase {
    
    var sut: TaskListViewController!

    override func setUpWithError() throws {
        // выносим однотипный код
        let storyboard = UIStoryboard(name: "Main", bundle:
                                      nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: TaskListViewController.self))
        
        sut = vc as? TaskListViewController
        
        sut.loadViewIfNeeded()
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    // метод проверяя действительно ли вьюконтроллер после загрузки имеет tableView
    func testWhenViewLoadedTableViewNotNil () {
        //убираем ниже тк работаем через storyboard
//        let sut = TaskListViewController() // sut - system under tests
//        _ = sut.view // проверяем на ViewDidLoad
        // еще вариант sut.loadViewIfNeeded*(
        
        
        // убираем в setUp
//        let storyboard = UIStoryboard(name: "Main", bundle:
//                                      nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: TaskListViewController.self))
//
//        let sut = vc as! TaskListViewController
        
        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(sut.tableView)
    }
    // тест который проверяет наличчие объекта дата провайдер после того как taskListViewController прогрузился - чтобы отдать всю логику в него - чтобы разгрузить vc
    func testWhenViewIsLoadedDataProviderIsNotNil() {
//        let storyboard = UIStoryboard(name: "Main", bundle:
//                                      nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: TaskListViewController.self))
//
//        let sut = vc as! TaskListViewController
        
//        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(sut.dataProvider)
    }
        // проверяем что при загрузки viewcontroller наш делегат будет установлен
    func testWhenViewIsLoadedTableViewDelegateIsSet() {
        XCTAssertTrue(sut.tableView.delegate is DataProvider)
    }
    func testWhenViewIsLoadedTableViewDataSourceIsSet() {
        XCTAssertTrue(sut.tableView.dataSource is DataProvider)
    }
    // проверим что и делегатом и датасорсом является dataProvider
    func testWhenViewIsLoadedTableViewDelegateEqualsTableViewDataSource() {
        XCTAssertEqual(sut.tableView.delegate as? DataProvider, sut.tableView.dataSource as? DataProvider)
    }
}
