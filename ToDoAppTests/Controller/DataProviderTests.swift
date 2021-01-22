//
//  DataProviderTests.swift
//  ToDoAppTests
//
//  Created by Denis Larin on 19.01.2021.
//

import XCTest
@testable import ToDoApp

class DataProviderTests: XCTestCase {
    
    var sut: DataProvider!
    var tableView: UITableView!
    
    var controller: TaskListViewController!

    override func setUpWithError() throws {
        sut = DataProvider()
        sut.taskManager = TaskManager()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            controller = storyboard.instantiateViewController(withIdentifier: String(describing: TaskListViewController.self)) as? TaskListViewController
        
        controller.loadViewIfNeeded()
        
        tableView = controller.tableView
        tableView.dataSource = sut
        tableView.delegate = sut
    }

    override func tearDownWithError() throws {
        
    }
    // действительно ли в нашем tableView - две секции
    func testNumberOfSectionsIsTwo() {
        // перенесем в setUp
//        let sut = DataProvider()
//        let tableView = UITableView()
//        tableView.dataSource = sut
        
        let numberOfSection = tableView.numberOfSections
        
        XCTAssertEqual(numberOfSection, 2)
    }
   // проверять что кол-во задач которые нужно выполнить равно кол-ву строк в первой секции tableView
    func testNumberOfRowsInSectionZeroIsTasksCount() {
//        let sut = DataProvider()
//        sut.taskManager = TaskManager()
//        let tableView = UITableView()
//        tableView.dataSource = sut
        
        sut.taskManager?.add(task: Task(title: "Foo"))
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        
        sut.taskManager?.add(task: Task(title: "Bar"))
        
        tableView.reloadData()
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 2)
    }
    
    func testNumberOfRowsInSectionOneIsTasksCount() {
//        let sut = DataProvider()
//        sut.taskManager = TaskManager()
//        let tableView = UITableView()
//        tableView.dataSource = sut
        
        sut.taskManager?.add(task: Task(title: "Foo"))
        sut.taskManager?.checkTask(at: 0)
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 1)
        
        sut.taskManager?.add(task: Task(title: "Bar"))
        sut.taskManager?.checkTask(at: 0)
        
        tableView.reloadData()
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 2)
    }
    //  проверим какую ячейку получаем в методе CellForRow от IndexPath
    func testCellForRowAtIndexPathReturnTaskCell() {
        sut.taskManager?.add(task: Task(title: "Foo"))
        tableView.reloadData()
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(cell is TaskCell)
    }
    // тест что метод CellForRowAtIndexPath переисользует ячейку от TableView
    // его работа ломает предыдущий тест
    func test_CellForRowAtIndexPath_Dequeues_CellFromTableView() {
//        let mockTableView = MockTableView()
        
        // данные строки одинаковые - можем отрефакторить код
        //выносим их в extension класса MockTableView
//        let mockTableView = MockTableView(frame: CGRect(x: 0, y: 0, width: 414, height: 818), style: .plain)
//        mockTableView.dataSource = sut
//        mockTableView.register(TaskCell.self, forCellReuseIdentifier: String(describing: TaskCell.self))
        let mockTableView = MockTableView.mockTableView(withDataSource: sut)
        
        sut.taskManager?.add(task: Task(title: "Foo"))
        mockTableView.reloadData()
        
        _ = mockTableView.cellForRow(at: IndexPath(row:0, section: 0))
        
        XCTAssertTrue(mockTableView.cellIsDequeued)
    }
        // срабатывает ли метод Configure в первой секции
    func test_CellForRowInSection_ZeroCalls_Configure() {
        
//        tableView.register(MockTaskCell.self, forCellReuseIdentifier: String(describing: TaskCell.self))
//        let mockTableView = MockTableView()
        
//        let mockTableView = MockTableView(frame: CGRect(x: 0, y: 0, width: 414, height: 818), style: .plain)
//        mockTableView.dataSource = sut
//        mockTableView.register(MockTaskCell.self, forCellReuseIdentifier: String(describing: TaskCell.self))
        let mockTableView = MockTableView.mockTableView(withDataSource: sut)
        
        
        let task = Task(title: "Foo")
            
//        sut.taskManager?.add(task: Task(title: "Foo"))
        sut.taskManager?.add(task: task)
        mockTableView.reloadData()
            
        let cell = mockTableView.cellForRow(at: IndexPath(row:0, section: 0)) as! MockTaskCell
        
        XCTAssertEqual(cell.task, task)
                    
    }
    // тест для второй секции
    func test_CellForRowInSection_OneCalls_Configure() {

//        tableView.register(MockTaskCell.self, forCellReuseIdentifier: String(describing: TaskCell.self))
//        let mockTableView = MockTableView(frame: CGRect(x: 0, y: 0, width: 414, height: 818), style: .plain) //  в этом случаее не указан размер tableView (ячейка nil) - указали размеры tableView - чтобы был не равен 0
//        print(mockTableView.frame.size) // в консоли выдает размер по нулям
//        mockTableView.dataSource = sut
//        mockTableView.register(MockTaskCell.self, forCellReuseIdentifier: String(describing: TaskCell.self))
        let mockTableView = MockTableView.mockTableView(withDataSource: sut)

        let task = Task(title: "Foo")
        // внутренняя оптимизация tableView - создаем task2
        let task2 = Task(title: "Bar")
        
        sut.taskManager?.add(task: task)
        sut.taskManager?.add(task: task2)
        sut.taskManager?.checkTask(at: 0)
        mockTableView.reloadData()

        let cell = mockTableView.cellForRow(at: IndexPath(row:0, section: 1)) as! MockTaskCell

        XCTAssertEqual(cell.task, task)
    }
    // тест появляющейся кнопки done
    func test_DeleteButtonTitle_SectionZero_ShowsDone() {
        let buttonTitle = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0 , section: 0))
        XCTAssertEqual(buttonTitle, "Done")
    }
    
    func test_DeleteButtonTitle_SectionOne_ShowsDone() {
        let buttonTitle = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0 , section: 1))
        XCTAssertEqual(buttonTitle, "UnDone")
    }
    //проверим что наш Task чекается в TaskManager
    func test_CheckingTask_Checks_InTaskManager() {
        let task = Task(title: "Foo")
        sut.taskManager?.add(task: task)
        
        tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(sut.taskManager?.tasksCount, 0)
        XCTAssertEqual(sut.taskManager?.doneTasksCount, 1)
    }
    func test_UnCheckingTask_Unchecks_InTaskManager () {
        let task = Task(title: "Foo")
        sut.taskManager?.add(task: task)
        sut.taskManager?.checkTask(at: 0)
        tableView.reloadData()
        
        tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 1))
        XCTAssertEqual(sut.taskManager?.tasksCount, 1)
        XCTAssertEqual(sut.taskManager?.doneTasksCount, 0)
    }
    
    
    
}
// воспользуемся extension DataProviderTests - где создаем класс для tableView - чтобы ограничить зону видимости для него
extension DataProviderTests {
    class MockTableView: UITableView {
        var cellIsDequeued = false // свойство
        
        static func mockTableView(withDataSource dataSource: UITableViewDataSource) -> MockTableView {
            let mockTableView = MockTableView(frame: CGRect(x: 0, y: 0, width: 414, height: 818), style: .plain)
            mockTableView.dataSource = dataSource
            mockTableView.register(MockTaskCell.self, forCellReuseIdentifier: String(describing: TaskCell.self))
            return mockTableView
        }
        
        // проверяем что ячейка переиспользуется
        override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
            cellIsDequeued = true
            
            return super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        }
        
    }
    //
    class MockTaskCell: TaskCell {
        var task: Task?
        
        override func configure(withTask task: Task, done: Bool = false) {
            self.task = task
        }
    }
}
