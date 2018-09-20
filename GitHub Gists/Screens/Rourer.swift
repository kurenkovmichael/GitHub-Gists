//
//  Rourer.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 14.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import UIKit
import Swinject

class Rourer {
    
    var window: UIWindow?
    var diContainer: Container

    init(withDiContainer diContainer: Container) {
        self.diContainer = diContainer
    }
    
    func showStartScreen() {
        let choseGistsModel = diContainer.choseGistsModel()
        let choseGistsVc = ChoseGistsSourseViewController.with(model: choseGistsModel, rourer: self)
        let nc = UINavigationController(rootViewController: choseGistsVc)
        nc.navigationBar.backgroundColor = UIColor.darkGray
        nc.navigationBar.barTintColor = UIColor.darkGray
        nc.navigationBar.isTranslucent = true
        nc.navigationBar.tintColor = UIColor.white
        nc.navigationBar.barStyle = .black
        
        
        if let filename = choseGistsModel.previousChosedUsername {
            let model = diContainer.gistsListModel(withUserName: filename)
            let gistsListVc = GistsListViewController.with(model: model, rourer: self)
            gistsListVc.reloadContentAfterAppeare = true
            nc.viewControllers = [choseGistsVc, gistsListVc]
        }
        
        setupWindow(mainNavigationController: nc);
    }
    
    func showGistsList(withUserName username: String) {
        let model = diContainer.gistsListModel(withUserName: username)
        let vc = GistsListViewController.with(model: model, rourer: self)
        vc.reloadContentAfterAppeare = true
        mainNavigationController!.pushViewController(vc, animated: true)
    }
    
    func showGistsGistsDetails(withUserName username: String, gistId: String) {
        let model = diContainer.gistDetailsModel(withUserName: username, gistId: gistId)
        let vc = GistDetailsViewController.with(model: model, rourer: self)
        vc.reloadContentAfterAppeare = true
        mainNavigationController!.pushViewController(vc, animated: true)
    }
    
    func showFileContent(withUserName username: String, gistId: String, filename: String) {
        let model = diContainer.fileContentModel(withUserName: username, gistId: gistId, filename: filename)
        let vc = FileContentViewController.with(model: model)
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
