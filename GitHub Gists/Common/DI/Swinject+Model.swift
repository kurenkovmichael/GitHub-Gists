//
//  Swinject+Model.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 20.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import Swinject

extension Container {
    
    func setup() {
        register(GitHubApi.self) { _ in GitHubApi() }
            .inObjectScope(.container)
        
        register(ChoseGistsModel.self) { r in ChoseGistsModel(api: r.resolve(GitHubApi.self)!) }
            .inObjectScope(.container)
        
        register(GistsListModel.self) { r, username in
            GistsListModel(withUsername: username, api: r.resolve(GitHubApi.self)!)
        }
        
        register(GistDetailsModel.self) { r, username, gistId in
            GistDetailsModel(withUsername: username, gistId: gistId, api: r.resolve(GitHubApi.self)!)
        }
        
        register(FileContentModel.self) { r, username, gistId, filename in
            FileContentModel(withUsername: username, gistId: gistId, filename: filename, api: r.resolve(GitHubApi.self)!)
        }
        
        register(CreateGistModel.self) { r in CreateGistModel(withApi: r.resolve(GitHubApi.self)!) }
    }
    
    // MARK: Factory
    
    func choseGistsModel() -> ChoseGistsModel {
        return resolve(ChoseGistsModel.self)! as ChoseGistsModel
    }
    
    func gistsListModel(withUserName username: String) -> GistsListModel {
        return resolve(GistsListModel.self, argument: username)! as GistsListModel
    }
    
    func gistDetailsModel(withUserName username: String, gistId: String) -> GistDetailsModel {
        return resolve(GistDetailsModel.self, arguments: username, gistId)! as GistDetailsModel
    }
    
    func fileContentModel(withUserName username: String, gistId: String, filename: String) -> FileContentModel {
        return resolve(FileContentModel.self, arguments: username, gistId, filename)! as FileContentModel
    }
 
    func createGistModel() -> CreateGistModel {
        return resolve(CreateGistModel.self)! as CreateGistModel
    }
    
}
