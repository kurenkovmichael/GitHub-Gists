//
//  GitHubApi+CreateGist.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 20.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import Foundation
import Alamofire

extension GitHubApi {

    private func createGistUrl() -> String {
        return "https://api.github.com/gists"
    }

    public func createGist(with description: String?, public isPublic: Bool, files: [String: String],
                           completion: @escaping (RequestResult<Gist>) -> Void) -> DataRequest {
        let parameters = createGistParameters(description: description, public: isPublic, files: files)
        return Alamofire.request(createGistUrl(),
                                 method: .post,
                                 parameters: parameters,
                                 encoding: JSONEncoding.default,
                                 headers: defaultHeaders())
            .response { (response) in
                if response.response?.statusCode == 401 {
                    completion(.error(.unauthorized))
                    return
                }

                guard response.error == nil else {
                    let gistsError = self.gistsError(from: response.error)
                    completion(.error(gistsError))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let loadedGist = try decoder.decode(Gist.self, from: response.data!)
                    completion(.success(loadedGist))
                } catch {
                    completion(.error(.noGists))
                }
        }
    }

    func createGistParameters(description: String?,
                              public isPublic: Bool,
                              files: [String: String]) -> Parameters {
        var parameters = Parameters()
        parameters["description"] = description
        parameters["public"] = isPublic
        parameters["files"] = files.mapValues { content in [ "content": content ] }

        return parameters
    }

}
