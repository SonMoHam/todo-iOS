//
//  Todo.swift
//  todo-iOS
//
//  Created by 손대홍 on 2021/07/11.
//

import Foundation

class Todo {
    let id: Int
    let content: String
    let deadline: String
    var isClear: Bool = false
    
    init(id: Int, content: String, deadline: String, isClear: Bool) {
        self.id = id
        self.content = content
        self.deadline = deadline
        self.isClear = isClear
    }
    
}
