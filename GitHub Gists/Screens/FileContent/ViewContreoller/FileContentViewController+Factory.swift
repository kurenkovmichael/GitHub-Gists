//
//  FileContentViewController+Factory.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 15.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import UIKit

extension FileContentViewController {

    static func with(model: FileContentModel) -> FileContentViewController {
        let viewController = FileContentViewController.init(nibName: "FileContentViewController", bundle: nil)
        viewController.model = model
        return viewController
    }

}
