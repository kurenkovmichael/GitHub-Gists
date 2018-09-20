//
//  GitHubApi+SingleGist.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 20.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import Foundation
import Alamofire

extension GitHubApi {
    
    private func gistUrl(with gistId: String) -> String {
        return "https://api.github.com/gists/\(gistId)"
    }
    
    public func loadGist(with gistId: String,
                         completion: @escaping (RequestResult<Gist>) -> Void) -> DataRequest {
        let url = gistUrl(with: gistId)
        return Alamofire.request(url, headers: defaultHeaders()).response { (response) in
            guard (response.error == nil) else {
                let gistsError = self.gistsError(from: response.error)
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
