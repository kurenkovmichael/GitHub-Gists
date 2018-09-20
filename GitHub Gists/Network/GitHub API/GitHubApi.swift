//
//  GitHubApi.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 15.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import Foundation
import Alamofire
import OAuthSwift
import KeychainAccess

class GitHubApi {
 
    enum RequestResult<ResultType> {
        case success(ResultType)
        case error(GistsError?)
    }
    
    let keychain = Keychain(service: "ru.mikhailkurenkov.example.github-api")
    let keychainTokenKey = "github-token"
    
    func defaultHeaders() -> HTTPHeaders? {
        if let token = keychain[keychainTokenKey] {
            return [ "Authorization" : "token \(token)" ]
        }
        return nil
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
        return Alamofire.request(url, headers: defaultHeaders()).response { (response) in
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
    
    // MARK: Login
    
    private let oauth = OAuth2Swift(
        consumerKey:    Bundle.main.gitHubClientId,
        consumerSecret: Bundle.main.gitHubClientSecret,
        authorizeUrl:   "https://github.com/login/oauth/authorize",
        accessTokenUrl: "https://github.com/login/oauth/access_token",
        responseType:   "code"
    )
    
    private var oauthRequestHandle: OAuthSwiftRequestHandle?
    
    func login(on viewController: UIViewController, completion: @escaping (RequestResult<String>)->Void)  {
        if keychain[keychainTokenKey] != nil {
            loadUser { result in
                switch result {
                case .success(let username):
                    completion(.success(username))
                default:
                    self.loginAsOauth(on: viewController, completion: completion)
                }
            }
        } else {
            loginAsOauth(on: viewController, completion: completion)
        }
    }
    
    func logout() {
        keychain[keychainTokenKey] = nil
    }
    
    private func loginAsOauth(on viewController: UIViewController, completion: @escaping (RequestResult<String>)->Void) {
        if let oldHandle = oauthRequestHandle {
            oldHandle.cancel()
        }
        
        oauth.authorizeURLHandler = SafariURLHandler(viewController: viewController, oauthSwift: oauth)
        oauthRequestHandle =
            oauth.authorize(withCallbackURL: URL(string: "githubgists://github-login")!,
                            scope: "gist", state:NSUUID().uuidString,
                            success: { credential, response, parameters in
                                self.oauthRequestHandle = nil
                                self.keychain[self.keychainTokenKey] = credential.oauthToken
                                self.loadUser(completion: completion)
            },
                            failure: { error in
                                self.oauthRequestHandle = nil
                                completion(.error(.unknownError(error: error)))
            })
    }
    
    private func userUrl() -> String {
        return "https://api.github.com/user"
    }
    
    func loadUser(completion: @escaping (RequestResult<String>)->Void) {
        Alamofire.request(userUrl(), headers: defaultHeaders()).response { (response) in
            guard response.error == nil else {
                let gistsError = self.gistsError(from: response.error)
                completion(.error(gistsError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let user = try decoder.decode(GitHubUser.self, from:response.data!)
                if let username = user.login {
                    completion(.success(username))
                } else {
                    completion(.error(.unknownError(error: nil)))
                }
            } catch {
                completion(.error(.unknownError(error: nil)))
            }
        }
    }
    
    // MARK: Error
    
    func gistsError(from error: Error?) -> GistsError {
        if error?.isNoConnection ?? false {
            return .noInternet(error: error)
        }
        return .unknownError(error: error)
    }
    
}