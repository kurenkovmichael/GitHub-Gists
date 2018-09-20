//
//  GitHubApi.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 15.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import Foundation
import Alamofire

class GitHubApi {
 
    enum RequestResult<ResultType> {
        case success(ResultType)
        case error(GistsError?)
    }
    
    // MARK: Gists List
    
    private func gistsListUrl(ofUserWithName username: String,
                                     page: Int, perPage: Int) -> String {
        return "https://api.github.com/users/\(username)/gists?page=\(page)&per_page=\(perPage)"
    }
    
    private func gistsListUrl(page: Int, perPage: Int) -> String {
        return "https://api.github.com/gists?page=\(page)&?per_page=\(perPage)"
    }
    
    public func loadGistsList(ofUserWithName username: String,
                              page: Int, perPage: Int,
                              completion: @escaping (RequestResult<[Gist]>) -> Void) -> DataRequest {
        let url = gistsListUrl(ofUserWithName: username, page: page, perPage: perPage)
        return Alamofire.request(url).response { (response) in
            guard response.error == nil else {
                var gistsError: GistsError?
                if let afError = response.error as? AFError, afError.isInvalidURLError {
                    gistsError = .userNotFound(username: username)
                } else if response.error?.isNoConnection ?? false {
                    gistsError = .noInternet(error: response.error)
                } else {
                    gistsError = .unknownError(error: response.error)
                }
                completion(.error(gistsError))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let loadedGists = try decoder.decode([Gist].self, from:response.data!)
                completion(.success(loadedGists))
            } catch {
                completion(.error(.userNotFound(username: username)))
            }
        }
    }
    
    // MARK: Single Gist
    
    private func gistUrl(with gistId: String) -> String {
        return "https://api.github.com/gists/\(gistId)"
    }
    
    public func loadGist(with gistId: String,
                         completion: @escaping (RequestResult<Gist>) -> Void) -> DataRequest {
        let url = gistUrl(with: gistId)
        return Alamofire.request(url).response { (response) in
            guard (response.error == nil) else {
                var gistsError: GistsError?
                if response.error?.isNoConnection ?? false {
                    gistsError = .noInternet(error: response.error)
                } else {
                    gistsError = .unknownError(error: response.error)
                }
                completion(.error(gistsError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let loadedGist = try decoder.decode(Gist.self, from:response.data!)
                completion(.success(loadedGist))
            } catch {
                completion(.error(.noGists))
            }
        }
    }
    
}
