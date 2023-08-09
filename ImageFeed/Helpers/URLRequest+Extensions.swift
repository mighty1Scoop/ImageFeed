//
//  URLSession+Extensions.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 08.08.2023.
//

import Foundation

fileprivate let defaultBaseURL = URL(string: "https://api.unsplash.com")!

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String = "GET",
        baseURL: URL = defaultBaseURL
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        return request
    }
}

