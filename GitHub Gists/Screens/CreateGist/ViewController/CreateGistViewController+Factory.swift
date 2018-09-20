//
//  CreateGistViewController+Factory.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 20.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import Foundation

extension CreateGistViewController {
    
    static func with(model: CreateGistModel, router: Rourer) -> CreateGistViewController {
        let vc = CreateGistViewController.init(nibName: "CreateGistViewController", bundle: nil)
        vc.model = model
        vc.router = router
        return vc;
    }
    
}
