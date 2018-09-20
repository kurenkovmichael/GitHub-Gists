//
//  GistsDetailsViewController+Factory.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 14.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import UIKit

extension GistDetailsViewController {
    
    static func with(model: GistDetailsModel, rourer: Rourer) -> GistDetailsViewController {
        let vc = GistDetailsViewController.init(nibName: "GistDetailsViewController", bundle: nil)
        vc.model = model
        vc.router = rourer
        return vc;
    }
    
}
