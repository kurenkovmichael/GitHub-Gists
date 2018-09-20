//
//  GistsDetailsViewController+Factory.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 14.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import UIKit

extension GistDetailsViewController {
    
    static func with(username: String, gistId: String, rourer: Rourer) -> GistDetailsViewController {
        let vc = GistDetailsViewController.init(nibName: nil, bundle: nil)
        vc.model = GistDetailsModel(withUsername: username, gistId: gistId)
        vc.router = rourer
        return vc;
    }
    
}
