//
//  TodoRowView.swift
//  todo-SwiftUI
//
//  Created by dhui on 2023/09/22.
//
import Foundation
import SwiftUI


struct TodoRowView: View {
    
    let aTodo: TodoEntity
    
    @State var isDone: Bool = false
    
    var onToggleChanged: (Bool) -> Void
    
    init(aTodo: TodoEntity, onToggleChanged: @escaping (Bool) -> Void) {
        self.aTodo = aTodo
        self.onToggleChanged = onToggleChanged
        self._isDone = State(wrappedValue: aTodo.isDone)
        print(#fileID, #function, #line, "- ")
    }
    
    var body: some View {
        HStack(content: {
            Text(aTodo.todo)
            Toggle(isOn: $isDone, label: { EmptyView() })
                .onChange(of: isDone) { _, newValue in
                    print(#fileID, #function, #line, "- aTodo: \(aTodo.refId), newValue: \(newValue)")
                    onToggleChanged(newValue)
                }
        })
    }
}
//
//#Preview {
//    TodoRowView()
//}
