//
//  Task.swift
//  ToDoList
//
//  Created by Luís Felipe Polo on 24/01/21.
//

import Foundation

struct Task {
    let title : String
    let priority : Priority
}

enum Priority : Int {
    case High = 0
    case Medium = 1
    case Low = 2
}
