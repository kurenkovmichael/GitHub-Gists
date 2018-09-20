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
    
    var localizedTitle: String? {
        switch self {
        case .noInternet(_):
            return NSLocalizedString("error.noInternet.title", comment: "")
            
        case .userNotFound(let username):
            return String.init(format: NSLocalizedString("error.userNotFound.titleformat", comment: ""), username)
            
        case .noGists:
            return NSLocalizedString("error.noGists.title", comment: "")
            
        case .gistNotFound:
            return NSLocalizedString("error.gistNotFound.title", comment: "")
            
        case .noFileContent:
            return NSLocalizedString("error.noFileContent.title", comment: "")
            
        default:
            return NSLocalizedString("error.serverError.title", comment: "")
        }
    }
    
    var localizedMessage: String? {
        switch self {
        case .noInternet(_):
            return NSLocalizedString("error.noInternet.subtitle", comment: "")
            
        case .userNotFound:
            return NSLocalizedString("error.userNotFound.subtitle", comment: "")
            
        case .noGists, .gistNotFound, .noFileContent:
            return nil
            
        default:
            return NSLocalizedString("error.serverError.subtitle", comment: "")
        }
    }
}
