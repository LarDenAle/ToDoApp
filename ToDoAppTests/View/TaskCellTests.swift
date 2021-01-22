//
//  TaskCellTests.swift
//  ToDoAppTests
//
//  Created by Denis Larin on 21.01.2021.
//

import XCTest
@testable import ToDoApp

class TaskCellTests: XCTestCase {
    
    var cell: TaskCell!
    
    override func setUpWithError() throws {
        // рефакторинг
        let storyboard = UIStoryboard(name: "Main", bundle:  nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: TaskListViewController.self)) as! TaskListViewController
        controller.loadViewIfNeeded()
        
        let tableView = controller.tableView
        
        let dataSource = FakeDataSource()
        tableView?.dataSource = dataSource
        
        cell = tableView?.dequeueReusableCell(withIdentifier: String(describing: TaskCell.self), for: IndexPath(row: 0, section: 0)) as? TaskCell
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_Cell_HasTitleLabel() {
        //  делаем рефакторинг - вырезаем следующий код
//        let storyboard = UIStoryboard(name: "Main", bundle:  nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: TaskListViewController.self)) as! TaskListViewController
//        controller.loadViewIfNeeded()
//
//        let tableView = controller.tableView
//
//        let dataSource = FakeDataSource()
//        tableView?.dataSource = dataSource
//
//        let cell = tableView?.dequeueReusableCell(withIdentifier: String(describing: TaskCell.self), for: IndexPath(row: 0, section: 0)) as! TaskCell
        
        XCTAssertNotNil(cell.titleLabel)
    }
    
    func test_Cell_HasTitleLabel_InContentView() {
        
        //
//        let storyboard = UIStoryboard(name: "Main", bundle:  nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: TaskListViewController.self)) as! TaskListViewController
//        controller.loadViewIfNeeded()
//
//        let tableView = controller.tableView
//
//        let dataSource = FakeDataSource()
//        tableView?.dataSource = dataSource
//
//        let cell = tableView?.dequeueReusableCell(withIdentifier: String(describing: TaskCell.self), for: IndexPath(row: 0, section: 0)) as! TaskCell
        
        XCTAssertTrue(cell.titleLabel.isDescendant(of: cell.contentView))
    }
    
    func test_Cell_Has_LocationLabel() {
        XCTAssertNotNil(cell.locationLabel)
    }
    
    func test_Cell_Has_LocationLabel_InContentView() {
        XCTAssertTrue(cell.locationLabel.isDescendant(of: cell.contentView))
    }
    
    func test_Cell_Has_DateLabel() {
        XCTAssertNotNil(cell.dateLabel)
    }
    func test_Cell_Has_DateLabel_InContentView() {
        XCTAssertTrue(cell.locationLabel.isDescendant(of: cell.contentView))
    }
    
    func test_Configure_Sets_Title() {
        let task = Task(title: "Foo")
        
        cell.configure(withTask: task)
        
        XCTAssertEqual(cell.titleLabel.text, task.title)
        
    }
    
    func test_Configure_Sets_Date() {
        let task = Task(title: "Foo")
        
        cell.configure(withTask: task)
        
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        let date = task.date
        let dateString = df.string(from: date)
        
        XCTAssertEqual(cell.dateLabel.text, dateString)
    }
    
    func test_Configure_Sets_LocationName() {
        let locatinon = Location(name: "Foo")
        let task = Task(title: "Bar", location: locatinon)
        
        cell.configure(withTask: task)
                       
        XCTAssertEqual(cell.locationLabel.text, task.location?.name)
    }
    // отрефакторим код
    func configure_Cell_WithTask() {
        let task = Task(title: "Foo")
        cell.configure(withTask: task, done: true)
    }
    
    func test_DoneTask_Should_StrikeThrough() {
//        let task = Task(title: "Foo")
//        cell.configure(withTask: task, done: true)
        configure_Cell_WithTask()
        
        let attributedString = NSAttributedString(string: "Foo", attributes: [NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue])
        
        XCTAssertEqual(cell.titleLabel.attributedText, attributedString)
    }
    
    func test_DoneTask_DateLabel_EqualsNil() {
        configure_Cell_WithTask()
//        let task = Task(title: "Foo")
//        cell.configure(withTask: task, done: true)
        XCTAssertNil(cell.dateLabel)
    }
    
    func test_DoneTask_LocationLabel_EqualsNil() {
        configure_Cell_WithTask()
//        let task = Task(title: "Foo")
//        cell.configure(withTask: task, done: true)
        XCTAssertNil(cell.locationLabel)
    }
    
    
}

extension TaskCellTests {
    class FakeDataSource: NSObject, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }
        
        
    }
}
