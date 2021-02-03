//
//  AddTaskViewController.swift
//  ToDoList
//
//  Created by Luís Felipe Polo on 24/01/21.
//

import Foundation
import UIKit
import RxSwift

class AddTaskViewController : UIViewController {
    
    @IBOutlet var taskTextField: UITextField!
    @IBOutlet var prioritySegmentedControl: UISegmentedControl!
    
    private let taskSubject = PublishSubject<Task>()
    var taskSubjectObservable : Observable<Task> {
        return taskSubject.asObservable()
    }
    
    @IBAction func savePressed(_ sender: Any) {
        guard let taskText = taskTextField.text, let priority = Priority(rawValue: prioritySegmentedControl.selectedSegmentIndex) else {
            return
        }
        
        let task = Task(title: taskText, priority: priority)
        taskSubject.onNext(task)
        
        self.dismiss(animated: true, completion: nil)
    }
}
