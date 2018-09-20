//
//  ChoseGistsModel.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 14.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import UIKit

class ChoseGistsModel {

    private let usernameKey = "Username"
    
    var previousChosedUsername: String? {
        return UserDefaults.standard.string(forKey: usernameKey)
    }
    
    func choseUsername( _ lastUsername: String?) {
        UserDefaults.standard.set(lastUsername, forKey: usernameKey)
    }
    
}
