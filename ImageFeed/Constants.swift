//
//  Constants.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 27.07.2023.
//

import Foundation

//let AccessKey = "jcx8QRPzoEuH3hBa1gvsLQMMvtoAP2t05MAGldh2Bw4"
let AccessKey = "2-qU9Ie3wyNwZfQPwXMFef1eshJu3LU7ahnhOCesqso"
//let AccessKey = "80_PFz_48eNJj9XwAqpmNLnUXSrS5Uq-5O1Ll_lpyGc"

//let SecretKey = "nKFpl3vnBE6ZLmUU94P646oFRs76bYN8wKZwCymsG3s"
let SecretKey = "3IRlengpaPK6_QY84o_kF2aAe3OrrKqQj3hfnRxIclc"
//let SecretKey = "EdvLq7rjn8SUIQEIjPFNPoLLS4IWxkg6penbqagOH64"

let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"

let DefaultURL = URL(string: "https://unsplash.com")
let DefaultAPIURL = URL(string: "https://api.unsplash.com")
let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultURL: URL?
    let defaultAPIURL: URL?
    let authURLString: String
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: AccessKey,
                                 secretKey: SecretKey,
                                 redirectURI: RedirectURI,
                                 accessScope: AccessScope,
                                 defaultURL: DefaultURL,
                                 defaultAPIURL: DefaultAPIURL,
                                 authURLString: UnsplashAuthorizeURLString
        )
    }
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultURL: URL?, defaultAPIURL: URL?, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultURL = defaultURL
        self.defaultAPIURL = defaultAPIURL
        self.authURLString = authURLString
    }
}
