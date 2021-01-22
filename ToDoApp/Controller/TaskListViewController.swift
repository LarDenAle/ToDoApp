//
//  ViewController.swift
//  ToDoApp
//
//  Created by Denis Larin on 18.01.2021.
//

import UIKit

class TaskListViewController: UIViewController {
//    var tableView: UITableView?
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var dataProvider: DataProvider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView = UITableView() // убираем т.к работаем через storyboard
    }


}

