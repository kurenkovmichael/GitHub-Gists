//
//  Gists.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 13.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import Foundation

class Gist: Codable {
    
    var id: String?
    var nodeId: String?
    
    var gistsDescription: String?
    
    var isPublic: Bool = false

    var createdAt: Date?
    var updatedAt: Date?

    var url: String?
    var forksUrl: String?
    var commitsUrl: String?

    var gitPullUrl: String?
    var gitPushUrl: String?
    var htmlUrl: String?

    var files: [String:GistFile] = [:]

    var comments: Int = 0
    var commentsUrl: String?

    var isTruncated: Bool?
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case nodeId = "node_id"
        case gistsDescription = "description"
        case isPublic = "public"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case url
        case forksUrl = "forks_url"
        case commitsUrl = "commits_url"
        case gitPullUrl = "git_pull_url"
        case gitPushUrl = "git_push_url"
        case htmlUrl = "html_url"
        case files
        case comments
        case commentsUrl = "comments_url"
        case isTruncated = "truncated"
    }
    
}
