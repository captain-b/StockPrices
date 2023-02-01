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
        // Initialise our main view controller.
        let storyBoard = UIStoryboard(name: Storyboard.main.rawValue, bundle: Bundle.main)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        // Set the home vc as our landing page.
        window?.rootViewController = (storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.home.rawValue) as? HomeViewController)!
        return true
    }
}

