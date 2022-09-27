//
//  AppDelegate.swift
//  NetFlix
//
//  Created by MAC on 6/26/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.rootViewController = LoginViewController()
//        window?.rootViewController = MainTabBarViewController()
        window?.rootViewController = UINavigationController(rootViewController: MainTabBarViewController())
//        window?.rootViewController = LibraryViewController()
        window?.makeKeyAndVisible()
        return true
    }

   

}

