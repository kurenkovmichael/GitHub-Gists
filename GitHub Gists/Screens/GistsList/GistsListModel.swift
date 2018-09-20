//
//  GistsListModel.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 12.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import Foundation
import Alamofire
import MagicalRecord

protocol GistsListModelObserver {
    func finishLoading(successful: Bool, withError error: GistsError?)
}

class GistsListModel {
    
    let username: String
    let api: GitHubApi
    
    var observer: GistsListModelObserver?

    var canCreateGist: Bool {
        return api.authorized
    }
    
    private var loadedPages = 0
    private let gistsOnPage = 20
    private var avtiveRequest: DataRequest?
    var isLoading: Bool {
        return avtiveRequest != nil
    }
    
    init(withUsername username: String, api: GitHubApi) {
        self.username = username
        self.api = api
    }
    
    func reloadGistsList() {
        loadGists(page: 0, append: false)
    }
    
    func loadNextPage() {
        loadGists(page: loadedPages + 1, append: true)
    }
    
    func obtainFRC() -> NSFetchedResultsController<GistEntity> {
        let predicate = GistEntity.predicate(with: self.username)
        return GistEntity.mr_fetchAllGrouped(by: nil, with: predicate, sortedBy: "order", ascending: true)
            as! NSFetchedResultsController<GistEntity>
    }
    
    // MARK: Private
    
    private func loadGists(page: Int, append: Bool) {
        if let oldRequest = avtiveRequest {
            oldRequest.cancel()
        }
        
        avtiveRequest = api.loadGistsList(ofUserWithName: username,
                                          page: page, perPage: gistsOnPage) { (result) in
            switch result {
            case .success(let loadedGists):
                MagicalRecord.saveGists(loadedGists, username: self.username, append: append) { (success, _) in
                    let error: GistsError? = loadedGists.isEmpty ? .noGists : nil
                    self.finishLoading(page: page, successful: success, withError: error)
                }
            case .error(let error):
                self.finishLoading(page: page, successful: false, withError: error)
            }
        }
    }
    
    private func finishLoading(page: Int, successful: Bool, withError error: GistsError?) {
        if successful {
            loadedPages = page
        }
        avtiveRequest = nil
        observer?.finishLoading(successful: successful, withError: error)
    }
    
}
