//
//  Bundle+Configuration.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 20.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import Foundation

extension Bundle {

    var gitHubClientId: String? {
        if let info = infoDictionary {
            return info["GitHub_Client_ID"] as? String
        }
        return nil
    }

    var gitHubClientSecret: String? {
        if let info = infoDictionary {
            return info["GitHub_Client_Secret"] as? String
        }
        return nil
    }
}
