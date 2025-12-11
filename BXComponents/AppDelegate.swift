//
//  AppDelegate.swift
//  BXComponents
//
//  Created by Chhailong on 7/9/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?


    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
      [.portrait]
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      window = UIWindow(frame: UIScreen.main.bounds)
      let vc = HorizontalSlideViewController()
      window?.rootViewController = vc

      window?.makeKeyAndVisible()

      return true
    }


}

