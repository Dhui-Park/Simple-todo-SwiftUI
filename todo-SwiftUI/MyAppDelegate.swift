//
//  MyAppDelegate.swift
//  todo-SwiftUI
//
//  Created by dhui on 2023/09/21.
//

import Foundation
import SwiftUI
import FirebaseCore


class MyAppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}
