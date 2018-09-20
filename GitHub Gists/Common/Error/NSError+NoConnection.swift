//
//  Error+NoConnection.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 20.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import Foundation

extension Error {
    
    var isNoConnection: Bool {
        return (self as NSError).domain == NSURLErrorDomain &&
               (self as NSError).code == NSURLErrorNotConnectedToInternet
    }
    
}
