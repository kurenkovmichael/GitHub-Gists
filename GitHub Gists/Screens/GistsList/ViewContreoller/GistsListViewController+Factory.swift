//
//  GistsListViewController+Factory.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 12.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import UIKit

extension GistsListViewController {

    static func with(model: GistsListModel, rourer: Rourer) -> GistsListViewController {
        let viewController = GistsListViewController.init(nibName: "GistsListViewController", bundle: nil)
        viewController.model = model
        viewController.router = rourer
        return viewController
    }

}
