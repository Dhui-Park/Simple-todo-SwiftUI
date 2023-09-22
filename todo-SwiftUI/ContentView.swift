//
//  ContentView.swift
//  todo-SwiftUI
//
//  Created by dhui on 2023/09/21.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var todosViewModel: TodosViewModel = TodosViewModel()
    
    @State fileprivate var userInput: String = ""
    
    let emptyStringInfoMsg: String = "할일이 비어있습니다"
    
    @State fileprivate var isShowingEmptyInputDialog: Bool = false
    
    
    /// 할일 수정 여부
    @State fileprivate var isEditingTodo: Bool = false
    @State fileprivate var editingTodo: TodoEntity? = nil
    @State fileprivate var editingTodoInput: String = ""
    
    var body: some View {
        VStack {
            inputHeaderView
            todoListView
        }
        .alert("수정",
               isPresented: $isEditingTodo,
               actions: {
            TextField("할일을 수정해주세요", text: $editingTodoInput)
            Button("닫기") { isEditingTodo = false }
            Button("완료") {
                guard let editingTodo = self.editingTodo else { return }
                todosViewModel.editTodo(refId: editingTodo.refId, userInput: editingTodoInput)
            }
        }, message: {
            Text("할일을 입력해주세요")
        })
        .alert("안내",
               isPresented: $isShowingEmptyInputDialog,
               actions: {
            Button("닫기") {
                isShowingEmptyInputDialog = false
            }
        }, message: {
            Text("할일을 입력해주세요")
        })
        
    }
    
    var inputHeaderView: some View {
        HStack {
            TextField("할일을 입력해주세요.", text: $userInput)
                .textFieldStyle(.roundedBorder)
            Button("할일 추가", action: {
                print(#fileID, #function, #line, "- ")
                
                if userInput.count < 1 {
                    isShowingEmptyInputDialog = true
                    return
                }
                todosViewModel.addTodo(userInput: userInput)
                userInput = ""
            })
            .buttonStyle(.borderedProminent)
        }
        .padding(.horizontal)
    }
    
    var todoListView: some View {
        List {
            ForEach($todosViewModel.todoList, id: \.id, content: { aTodo in
                TodoRowView(aTodo: aTodo.wrappedValue, onToggleChanged: { newValue in
                    todosViewModel.toggleIsDone(refId: aTodo.refId.wrappedValue, isDone: newValue)
                })
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button("수정", action: {
                        editingTodo = aTodo.wrappedValue
                        editingTodoInput = aTodo.todo.wrappedValue
                        isEditingTodo = true
                    }).tint(Color.orange)
                }
            })
            .onDelete(perform: { indexSet in
                todosViewModel.deleteTodoWithIndexSet(indexSet: indexSet)
            })
        }.environment(\.locale, Locale(identifier: "ko"))
    }
}

#Preview {
    ContentView()
}
