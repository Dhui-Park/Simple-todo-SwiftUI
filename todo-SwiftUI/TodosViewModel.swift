//
//  TodosViewModel.swift
//  todo-SwiftUI
//
//  Created by dhui on 2023/09/22.
//

import Foundation
import Combine
import FirebaseDatabase
import SwiftUI

class TodosViewModel: ObservableObject {
    
    var ref: DatabaseReference?
    
    @Published var todoList: [TodoEntity] = []
    
    init(){
        print(#fileID, #function, #line, "- ")
        ref = Database
            .database(url: "https://simple-todo-3b7ec-default-rtdb.asia-southeast1.firebasedatabase.app")
            .reference().child("todos")
        
        // Listen for deleted comments in the Firebase database
        // 삭제가 일어났을 때만 받겠다
        ref?.observe(.childRemoved, with: { (snapshot) -> Void in
            
            guard let index: Int = self.todoList.firstIndex(where: { $0.refId == snapshot.key }) else { return }
            
            withAnimation{
                self.todoList.remove(at: index)
            }
        })
        
        // Listen for new comments in the Firebase database
        // 데이터 추가가 일어났을 때만 받겠다
        ref?.observe(.childAdded, with: { (snapshot) -> Void in
            
            let value = snapshot.value as? NSDictionary
            let todo = value?["todo"] as? String ?? ""
            let isDone = value?["isDone"] as? Bool ?? false
            
            let addedTodoEntity = TodoEntity(refId: snapshot.key,
                                               todo: todo,
                                               isDone: isDone)
            print(#fileID, #function, #line, "- addedTodoEntity: \(addedTodoEntity)")
            
            withAnimation {
                // 1. 데이터 추가
                self.todoList.append(addedTodoEntity)
            }
            
           
        })
        
        // 특정 데이터가 변경되었을 때만 받겠다
        ref?.observe(.childChanged, with: { (snapshot) -> Void in
            
            guard let index: Int = self.todoList.firstIndex(where: { $0.refId == snapshot.key }) else { return }
            
            let value = snapshot.value as? NSDictionary
            let todo = value?["todo"] as? String ?? ""
            let isDone = value?["isDone"] as? Bool ?? false
            
            let changedTodoEntity = TodoEntity(refId: snapshot.key,
                                               todo: todo,
                                               isDone: isDone)
            print(#fileID, #function, #line, "- changedTodoEntity: \(changedTodoEntity)")
            
            
            withAnimation{
                // 1. 데이터 변경
                self.todoList[index] = changedTodoEntity
            }
        })
    }
    
    func deleteTodo(refId: String) {
        print(#fileID, #function, #line, "- refId: \(refId)")
        self.ref?.child(refId).removeValue()
    }
    
    
    /// 아이템 삭제
    /// - Parameter indexSet: <#indexSet description#>
    func deleteTodoWithIndexSet(indexSet: IndexSet) {
        print(#fileID, #function, #line, "- refId: \(indexSet)")
        
        guard let deletingTodoEntity = indexSet.map{ todoList[$0] }.first else {
            return
        }
        
        self.ref?.child(deletingTodoEntity.refId).removeValue()
    }
    
    func addTodo(userInput: String) {
        print(#fileID, #function, #line, "- ")
        
        self.ref?
            .childByAutoId()
            .setValue([
                "todo": userInput,
                "isDone": false
            ] as [String : Any])
    }
    
    func editTodo(refId: String, userInput: String) {
        self.ref?.child(refId)
            .updateChildValues(["todo": userInput], withCompletionBlock: {_,_ in })
    }
    
    func toggleIsDone(refId: String, isDone: Bool) {
        print(#fileID, #function, #line, "- refId: \(refId), isDone: \(isDone)")
        self.ref?.child(refId)
            .updateChildValues(["isDone": isDone], withCompletionBlock: {_,_ in })
    }
}
