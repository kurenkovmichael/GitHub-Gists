//
//  OAuthRequest.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 22.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import Foundation
import Alamofire
import OAuthSwift
import KeychainAccess
import SafariServices

protocol OAuthViewControllerProvider {
    func viewController() -> UIViewController?
}

class OAuthRequest: NSObject, SFSafariViewControllerDelegate {

    enum OAuthResult {
        case success(token: String)
        case canceled
        case error(Error?)
    }

    init(clientId: String,
         clientSecret: String,
         authorizeUrl: String,
         accessTokenUrl: String,
         responseType: String,
         on vcProvider: OAuthViewControllerProvider?,
         completion: @escaping (OAuthResult) -> Void) {
        self.oauth = OAuth2Swift(consumerKey: clientId,
                            consumerSecret: clientSecret,
                            authorizeUrl: authorizeUrl,
                            accessTokenUrl: accessTokenUrl,
                            responseType: responseType)
        self.vcProvider = vcProvider
        self.completion = completion
    }

    private var oauth: OAuth2Swift
    private var vcProvider: OAuthViewControllerProvider?
    private var completion: ((OAuthResult) -> Void)?

    private var oauthRequestHandle: OAuthSwiftRequestHandle?

    func login() {
        if let oldHandle = oauthRequestHandle {
            oldHandle.cancel()
        }

        if let viewController = vcProvider?.viewController() {
            let safariURLHandler = SafariURLHandler(viewController: viewController, oauthSwift: oauth)
            safariURLHandler.delegate = self
            oauth.authorizeURLHandler = safariURLHandler
        }

        oauthRequestHandle = oauth.authorize(withCallbackURL: URL(string: "githubgists://github-login")!,
                                             scope: "gist",
                                             state: NSUUID().uuidString,
                                             success: { credential, _, _ in
                                                self.oauthRequestHandle = nil
                                                if let completion = self.completion {
                                                    completion(.success(token: credential.oauthToken))
                                                }
        },
                                             failure: { error in
                                                self.oauthRequestHandle = nil
                                                if let completion = self.completion {
                                                    completion(.error(error))
                                                }
        })
    }

    func cancel() {
        if let oldHandle = oauthRequestHandle {
            oldHandle.cancel()
        }
        if let completion = self.completion {
            completion(.canceled)
        }
    }

    // MARK: SFSafariViewControllerDelegate

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        cancel()
    }

}
