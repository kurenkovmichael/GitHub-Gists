//
//  Rourer.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 14.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import UIKit
import Swinject

class Rourer: OAuthViewControllerProvider {
    
    var window: UIWindow?
    var diContainer: Container

    init(withDiContainer diContainer: Container) {
        self.diContainer = diContainer
    }
    
    func showStartScreen() {
        if let startScreenVC = mainNavigationController?.viewControllers.first {
            mainNavigationController!.popToViewController(startScreenVC, animated: true)
            return
        }
        
        let choseGistsModel = diContainer.choseGistsModel()
        let choseGistsVc = ChoseGistsSourseViewController.with(model: choseGistsModel, rourer: self)
        let nc = UINavigationController(rootViewController: choseGistsVc)
        nc.navigationBar.backgroundColor = UIColor.darkGray
        nc.navigationBar.barTintColor = UIColor.darkGray
        nc.navigationBar.isTranslucent = true
        nc.navigationBar.tintColor = UIColor.white
        nc.navigationBar.barStyle = .black
        
        if let username = choseGistsModel.previousChosedUsername {
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
    
    func showAlert(withError error: GistsError?, completion: (()->Void)? = nil) {
        let vc = UIAlertController(title: error?.localizedTitle,
                                   message: error?.localizedMessage,
                                   preferredStyle: .alert)
        
        let handler = completion != nil ? { (action: UIAlertAction) in completion!() } : nil
        vc.addAction(UIAlertAction(title: NSLocalizedString("errorAlert.cancelAction", comment: ""), style: .cancel, handler: handler))
        
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
    
    // MARK: OAuthViewControllerProvider
    
    func viewController() -> UIViewController? {
        return mainNavigationController?.topViewController
    }
    
}
