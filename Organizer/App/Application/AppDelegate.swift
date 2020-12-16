//
//  AppDelegate.swift
//  Organizer
//
//  Created by Olivier Miserez on 14/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var coordinator: MainCoordinator?
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print("🚨 DatabasePath: ", FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last ?? "Not Found!")
        print("🚨 DocumentsPath: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first ?? "Not Found")

        let navController = UINavigationController()
        navController.navigationBar.isTranslucent = false
        coordinator = MainCoordinator(navigationController: navController)
        coordinator?.start()
    
        window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
        return true
    }

    // MARK: UISceneSession Lifecycle

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }

}

