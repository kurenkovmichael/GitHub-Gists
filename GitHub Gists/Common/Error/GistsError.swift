//
//  GistsError.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 16.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import Foundation

enum GistsError: Error {
    case unknownError(error: Error?)
    case noInternet(error: Error?)
    case userNotFound(username: String)
    case noGists
    case gistNotFound
    case noFileContent
}
