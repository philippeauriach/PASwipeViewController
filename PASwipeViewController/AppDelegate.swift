//
//  AppDelegate.swift
//  MTSwipeViewController
//
//  Created by Philippe Auriach on 29/11/2014.
//  Copyright (c) 2014 Philippe Auriach. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        var viewControllers = Array<UIViewController>()
        
        for i in 0...4 {
            let vc = ViewController()
            vc.title = "title \(i)"
            
            if i==1 {
                vc.leftButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: nil, action: nil)
            } else if i == 2 {
                vc.leftButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: nil, action: nil)
                vc.rightButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: nil, action: nil)
            }
            
            viewControllers.append(vc)
        }
        
        let swipeVC = PASwipeViewController(viewControllers: viewControllers)
        
        swipeVC.onSwipeViewDidSwipe = { (selectedIndex:Int, selectedViewController:UIViewController) -> Void in
            println("changed to \(selectedIndex)")
        }
        
        let navVC = UINavigationController(rootViewController: swipeVC)
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        if let window = window {
            window.backgroundColor = UIColor.whiteColor()
            window.makeKeyAndVisible()
            window.rootViewController = navVC
        }
        
        /*dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
        swipeVC.scrollToViewController(3, animated: true)
        }*/
        
        return true
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

