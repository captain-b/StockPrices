//
//  AppDelegate.swift
//  StockPrice
//
//  Created by Babak Rezai on 31/01/2023.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let storyBoard = UIStoryboard(name: Storyboard.main.rawValue, bundle: Bundle.main)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.rootViewController = (storyBoard.instantiateViewController(withIdentifier: "home") as? HomeViewController)!
        return true
    }


}

