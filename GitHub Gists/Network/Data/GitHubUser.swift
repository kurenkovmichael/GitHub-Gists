//
//  GitHubUser.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 20.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import Foundation

class GitHubUser: Codable {
    var login: String?
    var id: Int?
    var url: String?
    var type: String?
    var name: String?
    var email: String?
}
