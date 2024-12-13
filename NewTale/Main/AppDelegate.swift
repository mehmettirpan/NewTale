//
//  AppDelegate.swift
//  NewTale
//
//  Created by Mehmet Tırpan on 3.10.2024.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
       // Create a new UIWindow instance and make it key and visible
       window = UIWindow(frame: UIScreen.main.bounds)
       
       // Create an instance of your initial view controller (e.g., ViewController)
       let rootViewController = MainViewController() // Your root view controller
       
       // Set the root view controller of the window
       window?.rootViewController = UINavigationController(rootViewController: rootViewController)
       
       // Make the window visible
       window?.makeKeyAndVisible()
       
       return true
   }


    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

