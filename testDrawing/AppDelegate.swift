//
//  AppDelegate.swift
//  testDrawing
//
//  Created by Julia Friberg on 2016-09-28.
//  Copyright © 2016 Julia Friberg. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func applicationDidFinishLaunching(_ application: UIApplication) {
        
        //Set tintcolor for navigationbar
        UINavigationBar.appearance().tintColor = UIColor(colorLiteralRed: (90/255), green: (200/255), blue: (250/255), alpha: 1)
        
        //Set up database
        FIRApp.configure()
        
        //Set up panoramaView
        let panoramaView = PanoramaView.shared()
        panoramaView?.setImage(#imageLiteral(resourceName: "BackgroundImage"))
        panoramaView?.orientToDevice = true     // Use motion sensors to pan
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    

}

