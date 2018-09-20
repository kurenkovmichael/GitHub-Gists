//
//  GistsListViewController+Factory.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 12.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import UIKit

extension GistsListViewController {

    static func with(username: String, rourer: Rourer) -> GistsListViewController {
        let vc = GistsListViewController.init(nibName: "GistsListViewController", bundle: nil)
        vc.model = GistsListModel(withUsername: username)
        vc.router = rourer
        return vc;
    }
    
}
