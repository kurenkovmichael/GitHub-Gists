//
//  GistsFile.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 13.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import Foundation

class GistFile: Codable {
    
    var filename: String?
    var type: String?
    var language: String?
    var rawUrl: String?
    var size: Int = 0
    var content: String?
    
    enum CodingKeys: String, CodingKey
    {
        case filename
        case type
        case language
        case rawUrl = "raw_url"
        case size
        case content
    }
    
}
