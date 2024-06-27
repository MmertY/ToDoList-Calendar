//
//  TodoEntity.swift
//  TodoListTakvim
//
//  Created by Mirhan Mert Yıldız on 25.06.2024.
//

import Foundation

class TodoEntity {
    var identifier: String
    var title : String
    var startDate : Date
    var finishDate : Date
    
    init(_ identifier: String, _ title: String, _ startDate: Date, _ finishDate: Date) {
        self.identifier = identifier
        self.title = title
        self.startDate = startDate
        self.finishDate = finishDate
    }
    
}
