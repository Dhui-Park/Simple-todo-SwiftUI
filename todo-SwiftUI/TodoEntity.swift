//
//  TodoEntity.swift
//  todo-SwiftUI
//
//  Created by dhui on 2023/09/22.
//

import Foundation

struct TodoEntity: Identifiable {
    var refId: String
    var todo: String
    var isDone: Bool = false
    var id: UUID = UUID()
}
