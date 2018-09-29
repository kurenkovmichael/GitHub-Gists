//
//  Swinject+Model.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 20.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import Swinject

extension Container {

    func setup(withOAuthVCProvider oauthVCProvider: OAuthViewControllerProvider) {
        register(GitHubApi.self) { _ in
            let api = GitHubApi()
            api.oauthViewControllerProvider = oauthVCProvider
            return api
            } .inObjectScope(.container)

        register(ChoseGistsModel.self) { resolver in
            ChoseGistsModel(api: resolver.resolve(GitHubApi.self)!)
            } .inObjectScope(.container)

        register(GistsListModel.self) { resolver, username in
            GistsListModel(withUsername: username,
                           api: resolver.resolve(GitHubApi.self)!)
        }

        register(GistDetailsModel.self) { resolver, username, gistId in
            GistDetailsModel(withUsername: username,
                             gistId: gistId,
                             api: resolver.resolve(GitHubApi.self)!)
        }

        register(FileContentModel.self) { resolver, username, gistId, filename in
            FileContentModel(withUsername: username,
                             gistId: gistId,
                             filename: filename,
                             api: resolver.resolve(GitHubApi.self)!)
        }

        register(CreateGistModel.self) { resolver in
            CreateGistModel(withApi: resolver.resolve(GitHubApi.self)!)
        }
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
