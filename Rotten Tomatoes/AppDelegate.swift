//
//  AppDelegate.swift
//  Rotten Tomatoes
//
//  Created by Andrew Wilkes on 8/26/15.
//  Copyright (c) 2015 Andrew Wilkes. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var storyboard: UIStoryboard?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        var tabBarController = UITabBarController()
        
        tabBarController.tabBar.barTintColor = UIColor.blackColor()
        tabBarController.tabBar.tintColor = UIColor.cyanColor()
        
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        var boxOfficeNavigationController = createTab("Top Box Office", url: "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json", image: "box_office") as UINavigationController
        
        var topDvdsNavigationController = createTab("Top DVD Rentals", url: "https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json", image: "dvd")
        
        tabBarController.viewControllers = [boxOfficeNavigationController, topDvdsNavigationController]
        
        window?.rootViewController = tabBarController
        
        return true
    }
    
    func createTab(title: String, url: String, image: String) -> UINavigationController
    {
        var navigationController = storyboard!.instantiateViewControllerWithIdentifier("MoviesNavigationController") as! UINavigationController
        
        navigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        navigationController.tabBarItem.title = nil
        
        var img = UIImage(named: image)
        navigationController.tabBarItem.image = img

        
        var boxOfficeViewController = navigationController.topViewController as! MoviesViewController
        boxOfficeViewController.url = NSURL(string: url)
        boxOfficeViewController.navTitle = title
        
        return navigationController
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

