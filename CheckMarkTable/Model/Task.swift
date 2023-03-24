//
//  Task.swift
//  CheckMarkTable
//
//  Created by Dastan on 17/3/23.
//

import Foundation

struct Task: Codable, Equatable {
    var id: String
    var title: String
    var isDone: Bool
    
    func changeProperty() -> Task {
        let task = Task(id: id, title: title, isDone: !isDone)
        return task
    }
}
