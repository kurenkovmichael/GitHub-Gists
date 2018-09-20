//
//  CreateGistModel.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 20.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import Foundation
import Alamofire

protocol CreateGistModelObserver {
    func finishCreateingGist(successful: Bool, withError error: GistsError?)
}

class CreateGistModel {
    
    let api: GitHubApi
    
    var observer: CreateGistModelObserver?
    
    init(withApi api: GitHubApi) {
        self.api = api
    }
    
    private var avtiveRequest: DataRequest?
    var loading: Bool {
        return avtiveRequest != nil
    }
    
    func createGist(description: String?, public isPublic: Bool, files: [String:String]) {
        if let oldRequest = avtiveRequest {
            oldRequest.cancel()
        }
        
        avtiveRequest = api.createGist(with: description, public: isPublic, files: files) { (result) in
            switch result {
            case .success:
                self.observer?.finishCreateingGist(successful: true, withError: nil)
                
            case .error(let error):
                self.observer?.finishCreateingGist(successful: false, withError: error)
            }
        }
    }
}
