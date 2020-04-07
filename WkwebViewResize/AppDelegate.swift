//
//  AppDelegate.swift
//  WkwebViewResize
//
//  Created by Çağan Kiraz on 7.04.2020.
//  Copyright © 2020 gelasdev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        setRootViewController(for: window)
        window?.makeKeyAndVisible()
        return true
    }
    
    private func setRootViewController(for window: UIWindow?) {
        let rootViewController = HomeViewController()
        let rootNavigationController = UINavigationController(rootViewController: rootViewController)
        rootNavigationController.navigationBar.isHidden = true
        window?.rootViewController = rootNavigationController
        window?.rootViewController = rootViewController
        
    }

}

