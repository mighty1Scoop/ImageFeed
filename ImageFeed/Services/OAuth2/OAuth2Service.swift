//
//  OAuthService.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 08.08.2023.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let urlSession = URLSession.shared
    private let tokenStorage = OAuth2TokenStorage()
    
    private (set) var authToken: String? {
        get {
            tokenStorage.token
        }
        set {
           tokenStorage.token = newValue
        }
    }
    
    private init() { }
    
    func fetchAuthToken(
        _ code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        let request: URLRequest = UnsplashApiRoutes.authTokenRequest(code: code)
        let task = object(for: request) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                completion(.success(authToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

private extension OAuth2Service {
     func object(
        for request: URLRequest,
        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                Result {
                  try decoder.decode(OAuthTokenResponseBody.self, from: data)
                }
            }
            completion(response)
        }
} }
