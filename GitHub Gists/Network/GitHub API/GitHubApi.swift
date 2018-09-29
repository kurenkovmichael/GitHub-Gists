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
import SafariServices

class GitHubApi {

    enum RequestResult<ResultType> {
        case success(ResultType)
        case error(GistsError?)
    }

    var oauthViewControllerProvider: OAuthViewControllerProvider?

    let keychain = Keychain(service: "ru.mikhailkurenkov.example.github-api")
    let keychainTokenKey = "github-token"

    func defaultHeaders() -> HTTPHeaders? {
        if let token = keychain[keychainTokenKey] {
            return [ "Authorization": "token \(token)" ]
        }
        return nil
    }

    // MARK: Login

    var authorized: Bool {
        return keychain[keychainTokenKey] != nil
    }

    func login(on viewController: UIViewController, completion: @escaping (RequestResult<String>) -> Void) {
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
        do {
            try keychain.remove(keychainTokenKey)
        } catch { }
    }

    private var oauthRequest: OAuthRequest?

    private func loginAsOauth(on viewController: UIViewController,
                              completion: @escaping (RequestResult<String>) -> Void) {
        if let oldRequest = oauthRequest {
            oldRequest.cancel()
        }

        guard let clientId = Bundle.main.gitHubClientId,
            let clientSecret = Bundle.main.gitHubClientSecret else {
                completion(.error(.unknownError(error: nil)))
                return
        }

        oauthRequest = OAuthRequest(clientId: clientId,
                                    clientSecret: clientSecret,
                                    authorizeUrl: "https://github.com/login/oauth/authorize",
                                    accessTokenUrl: "https://github.com/login/oauth/access_token",
                                    responseType: "code",
                                    on: oauthViewControllerProvider) { result in
            self.oauthRequest = nil

            switch result {
            case .success(let token):
                self.keychain[self.keychainTokenKey] = token
                self.loadUser(completion: completion)

            case .error(let error):
                completion(.error(.unknownError(error: error)))

            default:
                completion(.error(.unknownError(error: nil)))
            }
        }
        oauthRequest?.login()
    }

    private func userUrl() -> String {
        return "https://api.github.com/user"
    }

    func loadUser(completion: @escaping (RequestResult<String>) -> Void) {
        Alamofire.request(userUrl(), headers: defaultHeaders()).response { (response) in
            guard response.error == nil else {
                let gistsError = self.gistsError(from: response.error)
                completion(.error(gistsError))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let user = try decoder.decode(GitHubUser.self, from: response.data!)
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
