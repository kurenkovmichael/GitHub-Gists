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

    func obtainFRC() -> NSFetchedResultsController<GistEntity>? {
        let predicate = GistEntity.predicate(with: self.username)
        return GistEntity.mr_fetchAllGrouped(by: nil, with: predicate, sortedBy: "order", ascending: true)
            as? NSFetchedResultsController<GistEntity>
    }

    // MARK: Private

    private func loadGists(page: Int, append: Bool) {
        if let oldRequest = avtiveRequest {
            oldRequest.cancel()
        }

        avtiveRequest = api.loadGistsList(ofUserWithName: username,
                                          page: page,
                                          perPage: gistsOnPage) { result in
            switch result {
            case .success(let loadedGists):
                MagicalRecord.saveGists(loadedGists, username: self.username, append: append) { success, _ in
                    let error: GistsError? = loadedGists.isEmpty ? .noGists : nil
                    self.finishLoading(page: page, successful: success, withError: error)
                }
            case .error(let error):
                self.finishLoading(page: page, successful: false, withError: error)
            }
        }
    }
//    
//    private func loadGists(page: Int) {
//        if let oldRequest = avtiveRequest {
//            oldRequest.cancel()
//        }
//        
//        avtiveRequest = loadGistsList(ofUserWithName: username,
//                                          page: page, perPage: gistsOnPage)
//        { (result) in
//            switch result {
//            case .success(let loadedGists):
//                MagicalRecord.saveGists(loadedGists, username: self.username, append: false) { (success, _) in
//                    let error: GistsError? = loadedGists.isEmpty ? .noGists : nil
//                    self.finishLoading(page: page, successful: success, withError: error)
//                }
//            case .error(let error):
//                self.finishLoading(page: page, successful: false, withError: error)
//            }
//        }
//    }
//    
//    public func loadGistsList(ofUserWithName username: String,
//                              page: Int, perPage: Int,
//                              completion: @escaping (RequestResult<[Gist]>) -> Void) -> DataRequest {
//        let url = gistsListUrl(ofUserWithName: username, page: page, perPage: perPage)
//        return Alamofire.request(url, headers: defaultHeaders()).response { (response) in
//            guard response.error == nil else {
//                var gistsError: GistsError?
//                if let afError = response.error as? AFError, afError.isInvalidURLError {
//                    gistsError = .userNotFound(username: username)
//                } else if response.error?.isNoConnection ?? false {
//                    gistsError = .noInternet(error: response.error)
//                } else {
//                    gistsError = .unknownError(error: response.error)
//                }
//                completion(.error(gistsError))
//                return
//            }
//            
//            do {
//                let decoder = JSONDecoder()
//                decoder.dateDecodingStrategy = .iso8601
//                let loadedGists = try decoder.decode([Gist].self, from:response.data!)
//                completion(.success(loadedGists))
//            } catch {
//                completion(.error(.userNotFound(username: username)))
//            }
//        }
//    }
//    
//    static func saveGists(_ gistsToSave: [Gist],
//                          username:String,
//                          append: Bool,
//                          completion: @escaping (Bool, Error?)->Void)  {
//        MagicalRecord.save({ (context) in
//            if !append {
//                GistEntity.delete(with: username,
//                                  exclusionGistsWithIds: gistsToSave.compactMap { $0.id },
//                                  in: context)
//            }
//            
//            for gist in gistsToSave {
//                guard let gistId = gist.id else {
//                    continue
//                }
//                
//                let gistEntity = GistEntity.findOrCreate(with: username,
//                                                         id: gistId,
//                                                         in: context)
//                gistEntity.fill(from: gist)
//                
//                let files = gist.files.values
//                GistFileEntity.delete(from: gistEntity,
//                                      exclusionFilesWithNames: files.compactMap { $0.filename },
//                                      in: context)
//                for file in files {
//                    guard let filename = file.filename else {
//                        continue
//                    }
//                    let fileEntity = GistFileEntity.findOrCreate(with: filename,
//                                                                 gist: gistEntity,
//                                                                 in: context)
//                    fileEntity.fill(from: file, overwriteContent: false)
//                }
//            }
//        }, completion:completion)
//    }

    private func finishLoading(page: Int, successful: Bool, withError error: GistsError?) {
        if successful {
            loadedPages = page
        }
        avtiveRequest = nil
        observer?.finishLoading(successful: successful, withError: error)
    }

}
