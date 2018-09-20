//
//  ChoseGistsSourseViewController+Factory.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 14.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import UIKit

extension ChoseGistsSourseViewController {
    
    static func with(model: ChoseGistsModel, rourer: Rourer) -> ChoseGistsSourseViewController {
        let vc = ChoseGistsSourseViewController.init(nibName: "ChoseGistsSourseViewController", bundle: nil)
        vc.model = model
        vc.rourer = rourer
        return vc;
    }

}
