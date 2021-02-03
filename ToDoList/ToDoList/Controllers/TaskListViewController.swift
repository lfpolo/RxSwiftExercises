//
//  TaskListViewController.swift
//  ToDoList
//
//  Created by Luís Felipe Polo on 24/01/21.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa

class TaskListViewController : UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    let disposeBag = DisposeBag()
    private var tasks = BehaviorRelay<[Task]>(value: [])
    
    private var filteredTasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addTaskVC = (segue.destination as? UINavigationController)?.viewControllers.first as? AddTaskViewController {
            addTaskVC.taskSubjectObservable
                .subscribe(onNext: { [weak self] task in
                    guard let self = self else { return }
                    var newArray = self.tasks.value
                    newArray.append(task)
                    self.tasks.accept(newArray)
                    
                    let priority = Priority(rawValue: self.segmentedControl.selectedSegmentIndex - 1)
                    self.filterTasks(by: priority)
                    
                }).disposed(by: disposeBag)
        }
    }
    
    @IBAction func selectecPriority(_ sender: UISegmentedControl) {
        let priority = Priority(rawValue: self.segmentedControl.selectedSegmentIndex - 1)
        filterTasks(by: priority)
    }
    
    private func filterTasks(by priority: Priority?) {
        guard let priority = priority else {
            self.filteredTasks = tasks.value
            updateTableView()
            return
        }
        
        self.tasks.map { tasks in
            return tasks.filter { $0.priority == priority }
        }.subscribe(onNext: { [weak self] tasks in
            self?.filteredTasks = tasks
            self?.updateTableView()
        }).disposed(by: disposeBag)
    }
    
    func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension TaskListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath)
        cell.textLabel?.text = filteredTasks[indexPath.row].title
        return cell
    }
    
    
}
