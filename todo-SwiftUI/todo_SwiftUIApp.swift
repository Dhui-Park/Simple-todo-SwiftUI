//
//  todo_SwiftUIApp.swift
//  todo-SwiftUI
//
//  Created by dhui on 2023/09/21.
//

import SwiftUI

@main
struct todo_SwiftUIApp: App {
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(MyAppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
