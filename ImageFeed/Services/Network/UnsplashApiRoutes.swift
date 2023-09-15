//
//  UnsplashApiRoutes.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 08.08.2023.
//

import Foundation

//struct UnsplashApiRoutes {
//    static var selfProfileRequest: URLRequest {
//        URLRequest.makeHTTPRequest(path: "/me")
//    }
//
//    static func profileImageURLRequest(username: String, authToken: String) -> URLRequest {
//        var request = URLRequest.makeHTTPRequest(path: "/users/\(username)")
//        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
//        return request
//    }
//
//    static func photosRequest(page: Int, perPage: Int) -> URLRequest {
//        URLRequest.makeHTTPRequest(path: "/photos?"
//                                   + "page=\(page)"
//                                   + "&&per_page=\(perPage)"
//        )
//    }
//
//    static func likeRequest(photoId: String) -> URLRequest {
//        URLRequest.makeHTTPRequest(
//            path: "/photos/\(photoId)/like",
//            httpMethod: "POST"
//        )
//    }
//
//    static func unlikeRequest(photoId: String) -> URLRequest {
//        URLRequest.makeHTTPRequest(
//            path: "/photos/\(photoId)/like",
//            httpMethod: "DELETE"
//        )
//    }
//    static func authTokenRequest(code: String) -> URLRequest {
//        URLRequest.makeHTTPRequest(
//            path: "/oauth/token"
//            + "?client_id=\(AccessKey)"
//            + "&&client_secret=\(SecretKey)"
//            + "&&redirect_uri=\(RedirectURI)"
//            + "&&code=\(code)"
//            + "&&grant_type=authorization_code",
//            httpMethod: "POST",
//            baseURL: URL(string: "https://unsplash.com")!
//        )
//    }
//}
//
