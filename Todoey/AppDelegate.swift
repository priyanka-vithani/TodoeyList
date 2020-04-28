//
//  AppDelegate.swift
//  Todoey
//
//  Created by Apple on 06/04/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
      //  print(Realm.Configuration.defaultConfiguration.fileURL)
        
       
        do{
            _ = try Realm()
          
            
        }catch{
            print(error)
        }
        
        
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    func applicationWillTerminate(_ application: UIApplication) {
        
        
    }
    
    
}

