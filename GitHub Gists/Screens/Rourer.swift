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
        
        
        if let username = choseGistsModel.previousChosedUsername {
            choseGistsVc.keepAuthorization = true

            let model = diContainer.gistsListModel(withUserName: username)
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
    
    func showCreateGist() {
        let model = diContainer.createGistModel()
        let vc = CreateGistViewController.with(model: model, router: self)
        mainNavigationController!.pushViewController(vc, animated: true)
    }
    
    func hideCurrentScreen() {
        mainNavigationController!.popViewController(animated: true)
    }
    
    func showAlert(withError error: GistsError?) {
        let vc = UIAlertController.init(title: error?.localizedTitle, message: nil, preferredStyle: .alert)
        vc.addAction(UIAlertAction.init(title: NSLocalizedString("errorAlert.cancelAction", comment: ""), style: .cancel, handler: nil))
        mainNavigationController!.topViewController?.present(vc, animated: true, completion: nil)
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
