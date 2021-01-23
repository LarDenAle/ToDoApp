//
//  AppDelegate.swift
//  ToDoApp
//
//  Created by Denis Larin on 18.01.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        #if targetEnvironment(simulator)
        if CommandLine.arguments.contains("--UITesting") {
            resetState()
        }
        #endif
        return true
    }

    private func resetState() {
        guard
            let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
            let url = URL(string: "\(documentPath)tasks.plist") else { return }
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: url)
    }
    // MARK: UISceneSession Lifecycle
// 
}

