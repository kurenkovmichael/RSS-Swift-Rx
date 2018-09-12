//
//  AppDelegate.swift
//  RSS-Swift-Rx
//
//  Created by Михаил Куренков on 15.11.17.
//  Copyright © 2017 Михаил Куренков. All rights reserved.
//

import UIKit
import MagicalRecord
import Hero

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UIGestureRecognizerDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        MagicalRecord.setupCoreDataStack()
        
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().tintColor = .darkBlue
        UIButton.appearance().tintColor = .darkBlue
        UIView.appearance().tintColor = .darkBlue
        
        let vc = NewsSourcesViewController.init(nibName: "NewsSourcesViewController", bundle: nil)
        let nc = UINavigationController(rootViewController: vc)
        nc.interactivePopGestureRecognizer?.delegate = self

        nc.isHeroEnabled = true
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nc
        self.window?.makeKeyAndVisible()
        
        return true
    }

    // <UIGestureRecognizerDelegate>
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
    }
}

