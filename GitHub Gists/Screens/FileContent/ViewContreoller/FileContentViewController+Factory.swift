//
//  FileContentViewController+Factory.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 15.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import UIKit

extension FileContentViewController {

    static func with(username: String, gistId: String, filename: String) -> FileContentViewController {
        let vc = FileContentViewController.init(nibName: "FileContentViewController", bundle: nil)
        vc.model = FileContentModel(withUsername: username, gistId: gistId, filename: filename)
        return vc;
    }
    
}
