//
//  ChoseGistsModel.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 14.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import UIKit

enum GitHubLoginResult {
    case success(username: String)
    case error
}

class ChoseGistsModel {

    let api: GitHubApi
    
    init(api: GitHubApi) {
        self.api = api
    }
    
    // MARK: Entered GitHub name
    
    private let usernameKey = "Username"
    
    var previousChosedUsername: String? {
        return UserDefaults.standard.string(forKey: usernameKey)
    }
    
    func choseUsername( _ lastUsername: String?) {
        UserDefaults.standard.set(lastUsername, forKey: usernameKey)
    }
    
    func cleanChosedUsername() {
        UserDefaults.standard.removeObject(forKey: usernameKey)
    }
    
    // MARK: Login
  
    func loginToGitHub(on viewController: UIViewController, completion: @escaping (GitHubLoginResult)->Void)  {
        api.login(on: viewController) { (result) in
            switch result {
            case .success(let username):
                self.choseUsername(username)
                completion(.success(username: username))
            default:
                completion(.error)
            }
        }
    }
    
    func logout() {
        cleanChosedUsername()
        api.logout()
    }
    
}
