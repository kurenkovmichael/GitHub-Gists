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
import OAuthSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let container = Container()
    var rourer: Rourer!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        MagicalRecord.setupCoreDataStack()

        rourer = Rourer(withDiContainer: container)
        container.setup(withOAuthVCProvider: rourer)

        rourer.showStartScreen()

        return true
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if url.scheme == "githubgists" && url.host == "github-login" {
            OAuthSwift.handle(url: url)
        }
        return true
    }

}
