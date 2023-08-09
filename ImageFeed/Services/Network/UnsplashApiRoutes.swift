//
//  UnsplashApiRoutes.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 08.08.2023.
//

import Foundation

var selfProfileRequest: URLRequest {
    URLRequest.makeHTTPRequest(path: "/me")
}
func profileImageURLRequest(username: String) -> URLRequest {
    URLRequest.makeHTTPRequest(path: "/users/\(username)")
}
func photosRequest(page: Int, perPage: Int) -> URLRequest {
    URLRequest.makeHTTPRequest(path: "/photos?"
                               + "page=\(page)"
                               + "&&per_page=\(perPage)"
    )
}
func likeRequest(photoId: String) -> URLRequest {
    URLRequest.makeHTTPRequest(
        path: "/photos/\(photoId)/like",
        httpMethod: "POST"
    )
}
func unlikeRequest(photoId: String) -> URLRequest {
    URLRequest.makeHTTPRequest(
        path: "/photos/\(photoId)/like",
        httpMethod: "DELETE"
    )
}
func authTokenRequest(code: String) -> URLRequest {
    URLRequest.makeHTTPRequest(
        path: "/oauth/token"
        + "?client_id=\(AccessKey)"
        + "&&client_secret=\(SecretKey)"
        + "&&redirect_uri=\(RedirectURI)"
        + "&&code=\(code)"
        + "&&grant_type=authorization_code",
        httpMethod: "POST",
        baseURL: URL(string: "https://unsplash.com")!
    )
}
