//
//  Bundle+Configuration.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 20.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import Foundation

extension Bundle {
    
    var gitHubClientId: String {
        return infoDictionary! ["GitHub_Client_ID"] as! String
    }
    
    var gitHubClientSecret: String {
        return infoDictionary! ["GitHub_Client_Secret"] as! String
    }
}
