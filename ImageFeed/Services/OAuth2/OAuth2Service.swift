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
    
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    func fetchAuthToken(
        _ code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        let request: URLRequest = authTokenRequest(code: code)
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

extension OAuth2Service {
    private func object(
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
