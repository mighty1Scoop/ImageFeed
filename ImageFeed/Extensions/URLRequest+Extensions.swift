//
//  URLSession+Extensions.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 08.08.2023.
//

import Foundation

enum HTTPRequestMethod: String {
    case GET = "GET"
    case POST = "POST"
    case DELETE = "DELETE"
}

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: HTTPRequestMethod,
        baseURL: URL? = Constants.DefaultBaseApiURL
    ) -> URLRequest? {
        guard let url = URL(string: path, relativeTo: baseURL) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        if let token = OAuth2TokenStorage.shared.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
}
