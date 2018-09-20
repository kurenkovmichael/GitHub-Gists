//
//  Rourer.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 14.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import UIKit

class Rourer {
    
    var window: UIWindow?

    func showStartScreen() {
        let choseGistsModel = ChoseGistsModel();
        let choseGistsVc = ChoseGistsSourseViewController.with(model: choseGistsModel, rourer: self)
        let nc = UINavigationController(rootViewController: choseGistsVc)
        nc.navigationBar.backgroundColor = UIColor.darkGray
        nc.navigationBar.barTintColor = UIColor.darkGray
        nc.navigationBar.isTranslucent = true
        nc.navigationBar.tintColor = UIColor.white
        nc.navigationBar.barStyle = .black
        
        
        if let username = choseGistsModel.previousChosedUsername {
            let gistsListVc = GistsListViewController.with(username: username,
                                                           rourer: self)
            gistsListVc.reloadContentAfterAppeare = true
            nc.viewControllers = [choseGistsVc, gistsListVc]
        }
        
        setupWindow(mainNavigationController: nc);
    }
    
    func showGistsList(withUserName username: String) {
        let vc = GistsListViewController.with(username: username, rourer: self)
        vc.reloadContentAfterAppeare = true
        mainNavigationController!.pushViewController(vc, animated: true)
    }
    
    func showGistsGistsDetails(withUserName username: String, gistId: String) {
        let vc = GistDetailsViewController.with(username: username, gistId: gistId, rourer: self)
        vc.reloadContentAfterAppeare = true
        mainNavigationController!.pushViewController(vc, animated: true)
    }
    
    func showFileContent(withUserName username: String, gistId: String, filename: String) {
        let vc = FileContentViewController.with(username: username, gistId: gistId, filename: filename)
        mainNavigationController!.pushViewController(vc, animated: true)
    }
    
    // MARK: Private
    
    private func setupWindow(mainNavigationController: UINavigationController) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = mainNavigationController
        window!.makeKeyAndVisible()
    }
    
    private var mainNavigationController: UINavigationController? {
        return window?.rootViewController as? UINavigationController
    }
}
