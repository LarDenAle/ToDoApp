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
        super.setUp()
        // выносим однотипный код
        let storyboard = UIStoryboard(name: "Main", bundle:
                                      nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: TaskListViewController.self))
        
        sut = vc as? TaskListViewController
        
        sut.loadViewIfNeeded()
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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
    
    func test_TaskListVC_HasAddBarButtonWithSelfAsTarget() {
        let target = sut.navigationItem.rightBarButtonItem?.target
        XCTAssertEqual(target as? TaskListViewController, sut)
    }
    
    
    
    func test_AddNewTaskPresents_NewTaskViewController() {
        XCTAssertNil(sut.presentedViewController)
    }
    // рефакторим код
    func presentingNewTaskViewController() -> NewTaskViewController {
        
        guard
            let newTaskButton = sut.navigationItem.rightBarButtonItem,
            let action = newTaskButton.action else {
                
                return NewTaskViewController()
        }
        
        UIApplication.shared.keyWindow?.rootViewController = sut
        sut.performSelector(onMainThread: action, with: newTaskButton, waitUntilDone: true)
        
        let newTaskViewController = sut.presentedViewController as! NewTaskViewController
        return newTaskViewController
    }
   
    func testAddNewTaskPresentsNewTaskViewController() {
        XCTAssertNil(sut.presentedViewController)
        
//        guard
//            let newTaskButton = sut.navigationItem.rightBarButtonItem,
//            let action = newTaskButton.action else {
//                XCTFail()
//                return
//        }
//        UIApplication.shared.keyWindow?.rootViewController = sut
//        sut.performSelector(onMainThread: action, with: newTaskButton, waitUntilDone: true)
//        XCTAssertNotNil(sut.presentedViewController)
//        XCTAssertTrue(sut.presentedViewController is NewTaskViewController)
//
//        let newTaskViewController = sut.presentedViewController as! NewTaskViewController
        let newTaskViewController = presentingNewTaskViewController()
        XCTAssertNotNil(newTaskViewController.titleTextField)
    
    }
    
    func testSharesSameTaskManagerWithNewTaskVC() {
        XCTAssertNil(sut.presentedViewController)
        
//        guard
//            let newTaskButton = sut.navigationItem.rightBarButtonItem,
//            let action = newTaskButton.action else {
//                XCTFail()
//                return
//        }
//        UIApplication.shared.keyWindow?.rootViewController = sut
//        sut.performSelector(onMainThread: action, with: newTaskButton, waitUntilDone: true)
//        XCTAssertNotNil(sut.presentedViewController)
//        XCTAssertTrue(sut.presentedViewController is NewTaskViewController)
//
//        let newTaskViewController = sut.presentedViewController as! NewTaskViewController
        let newTaskViewController = presentingNewTaskViewController()
        XCTAssertNotNil(sut.dataProvider.taskManager)
        XCTAssertTrue(newTaskViewController.taskManager === sut.dataProvider.taskManager) // === проверка что это один и тот же объект - применим только к классам
    
    }
    
    func testWhenViewAppearedTableViewReloaded () {
        let mockTableView = MockTableView()
        sut.tableView = mockTableView
        
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        
        XCTAssertTrue((sut.tableView as! MockTableView).isReloaded)
    }
    
    func testTappingCellSendsNotification() {
        let task = Task(title: "Foo")
        sut.dataProvider.taskManager!.add(task: task)
        
        expectation(forNotification: NSNotification.Name(rawValue: "DidSelectRow notification"), object: nil) { notification -> Bool in
            
            guard let taskFromNotification = notification.userInfo?["task"] as? Task else {
                return false
            }
            
            return task == taskFromNotification
        }
        
        let tableView = sut.tableView
        tableView?.delegate?.tableView!(tableView!, didSelectRowAt: IndexPath(row: 0, section: 0))
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testSelectedCellNotificationPushesDetailVC() {
        let mockNavigationController = MockNavigationController(rootViewController: sut)
        UIApplication.shared.keyWindow?.rootViewController = mockNavigationController
        
        sut.loadViewIfNeeded()
        let task = Task(title: "Foo")
        let task1 = Task(title: "Bar")
        sut.dataProvider.taskManager?.add(task: task)
        sut.dataProvider.taskManager?.add(task: task1)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DidSelectRow notification"), object: self, userInfo: ["task": task1])
        
        guard let detailViewController = mockNavigationController.pushedViewController as? DetailViewController else {
            XCTFail()
            return
        }
        
        detailViewController.loadViewIfNeeded()
        XCTAssertNotNil(detailViewController.titleLabel)
        XCTAssertTrue(detailViewController.task == task1)
    }
}

extension TaskListViewControllerTests {
    class MockTableView: UITableView {
        var isReloaded = false
        override func reloadData() {
            isReloaded = true
        }
    }
}

extension TaskListViewControllerTests {
    class MockNavigationController: UINavigationController {
        var pushedViewController: UIViewController?
        
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            pushedViewController = viewController
            super.pushViewController(viewController, animated: animated)
        }
    }
}
