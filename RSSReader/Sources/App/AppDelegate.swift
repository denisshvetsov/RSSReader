//
//  AppDelegate.swift
//  RSSReader
//
//  
//  Copyright © 2018 Denis Shvetsov. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let predefinedFeeds = PredefinedFeeds()
        predefinedFeeds.addPredefinedFeeds()
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataService.shared.saveContext()
    }

}

