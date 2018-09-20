//
//  AppDelegate.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 12.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import UIKit
import MagicalRecord
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let container = Container()
    var rourer: Rourer!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        MagicalRecord.setupCoreDataStack()
        container.setup()
        
        rourer = Rourer(withDiContainer: container)
        rourer.showStartScreen()
        
        return true
    }
    
}

