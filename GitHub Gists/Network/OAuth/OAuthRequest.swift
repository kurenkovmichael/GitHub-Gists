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

class OAuthRequest: NSObject, SFSafariViewControllerDelegate {
    
    enum OAuthResult {
        case success(oauthToken: String, oauthRefreshToken: String, oauthTokenExpiresAt: Date?)
        case canceled
        case error(Error?)
    }
    
    init(clientId: String,
         clientSecret: String,
         authorizeUrl: String,
         accessTokenUrl: String,
         responseType: String,
         on viewController: UIViewController?,
         completion: @escaping (OAuthResult)->Void) {
        
        self.oauth = OAuth2Swift(consumerKey: clientId,
                            consumerSecret: clientSecret,
                            authorizeUrl: authorizeUrl,
                            accessTokenUrl: accessTokenUrl,
                            responseType:  responseType )
        
        if let vc = viewController {
            self.oauth.authorizeURLHandler = SafariURLHandler(viewController: vc, oauthSwift: oauth)
        }
        
        self.completion = completion
    }
    
    private var oauth: OAuth2Swift
    private var completion: ((OAuthResult)->Void)?
    
    private var oauthRequestHandle: OAuthSwiftRequestHandle?
    
    func login() {
        if let oldHandle = oauthRequestHandle {
            oldHandle.cancel()
        }
        
        if let safariURLHandler = oauth.authorizeURLHandler as? SafariURLHandler {
            safariURLHandler.delegate = self
        }
        
        oauthRequestHandle =
            oauth.authorize(withCallbackURL: URL(string: "githubgists://github-login")!,
                            scope: "gist", state:NSUUID().uuidString,
                            success: { credential, response, parameters in
                                self.oauthRequestHandle = nil
                                if let completion = self.completion {
                                    completion(.success(oauthToken: credential.oauthToken,
                                                        oauthRefreshToken: credential.oauthRefreshToken,
                                                        oauthTokenExpiresAt: credential.oauthTokenExpiresAt))
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
