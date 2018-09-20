//
//  GistsDetailsModel.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 14.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import Foundation
import Alamofire
import MagicalRecord

protocol GistDetailsModelObserver {
    func finishLoading(successful: Bool, withError error: GistsError?)
}

class GistDetailsModel {
    
    let username: String
    let gistId: String

    let api: GitHubApi

    var observer: GistDetailsModelObserver?

    private var avtiveRequest: DataRequest?
    var loading: Bool {
        return avtiveRequest != nil
    }
    
    init(withUsername username: String, gistId: String, api: GitHubApi) {
        self.username = username
        self.gistId = gistId
        self.api = api
    }
    
    public func obtainGistEntity() -> GistEntity? {
        let predicate = GistEntity.predicate(with: username, id: gistId)
        return GistEntity.mr_findFirst(with: predicate) as? GistEntity
    }
    
    func obtainFilesFRC() -> NSFetchedResultsController<GistFileEntity> {
        let predicate = GistFileEntity.predicate(with: gistId)
        return GistFileEntity.mr_fetchAllGrouped(by: nil, with: predicate, sortedBy: "order", ascending: true)
            as! NSFetchedResultsController<GistFileEntity>
    }

    public func reloadGist() {
        if let oldRequest = avtiveRequest {
            oldRequest.cancel()
        }
        
        avtiveRequest = api.loadGist(with: gistId) { (result) in
            switch result {
            case .success(let loadedGist):
                MagicalRecord.saveGist(loadedGist, username: self.username) { (success, error) in
                    var gistsError: GistsError?
                    if let error = error {
                        gistsError = .unknownError(error: error)
                    }
                    self.finishLoading(successful: success, withError: gistsError)
                }
            case .error(let error):
                self.finishLoading(successful: false, withError: error)
            }
        }
    }
    
    private func finishLoading(successful: Bool, withError error: GistsError?) {
        avtiveRequest = nil
        observer?.finishLoading(successful: successful, withError: error)
    }
    
}
