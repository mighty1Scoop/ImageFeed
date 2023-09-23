//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 23.09.2023.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest
    func code(from url: URL) -> String?
}

final class AuthHelper: AuthHelperProtocol {
    
    let configuration: AuthConfiguration
    
    private struct QueryKeys {
        static let clientId = "client_id"
        static let redirectURI = "redirect_uri"
        static let responseType = "response_type"
        static let accessScope = "scope"
    }
    
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
    
    func authRequest() -> URLRequest {
        let url = authURL()
        return URLRequest(url: url)
    }

    func code(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where:  { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    func authURL() -> URL {
        var urlComponents = URLComponents(string: configuration.authURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: QueryKeys.clientId, value: configuration.accessKey),
            URLQueryItem(name: QueryKeys.redirectURI, value: configuration.redirectURI),
            URLQueryItem(name: QueryKeys.responseType, value: "code"),
            URLQueryItem(name: QueryKeys.accessScope, value: configuration.accessScope)
        ]
        return urlComponents.url!
    }
}
