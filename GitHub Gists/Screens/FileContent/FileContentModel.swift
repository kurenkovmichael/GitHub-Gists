//
//  FileContentModel.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 20.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import Foundation
import Alamofire
import MagicalRecord

protocol FileContentModelObserver {
    func finishLoading(successful: Bool, withError error: GistsError?)
}

class FileContentModel {
    
    let username: String
    let gistId: String
    let filename: String
    
    let api: GitHubApi

    var observer: FileContentModelObserver?
    
    private var avtiveRequest: DataRequest?
    var loading: Bool {
        return avtiveRequest != nil
    }
    
    init(withUsername username:String, gistId: String, filename: String, api: GitHubApi) {
        self.username = username
        self.gistId = gistId
        self.filename = filename
        self.api = api
    }
    
    public func obtainFileEntity() -> GistFileEntity? {
        let predicate = GistFileEntity.predicate(withGistId: gistId, filename: filename)
        return GistFileEntity.mr_findFirst(with: predicate) as? GistFileEntity
    }
    
    public func reloadContent() {
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
