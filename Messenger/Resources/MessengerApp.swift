//
//  MessengerApp.swift
//  Messenger
//
//  Created by Paulo Orquillo on 24/04/21.
//

import SwiftUI
import Firebase

@main
struct MessengerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            ConversationListView()
                .environmentObject(AppStateModel())
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("did launch")
        FirebaseApp.configure()
        return true
    }
}
