//
//  UIButton+UI.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 20.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import UIKit

extension UIButton {
    
    func configureUI() {
        backgroundColor = .darkGray
        setTitleColor(.white, for: .normal)
        setTitleColor(.lightGray, for: .disabled)
        setTitleColor(.lightGray, for: .highlighted)
        
        layer.cornerRadius = 22
        layer.masksToBounds = true
    }
    
}
