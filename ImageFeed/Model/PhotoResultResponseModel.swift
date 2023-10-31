//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 16.09.2023.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let createdAt: String?
    let width: CGFloat
    let height: CGFloat
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult
}

struct UrlsResult: Codable {
    let raw: String?
    let small: String?
    let thumb: String?
    let full: String?
}

struct LikeResponse: Codable {
    let photo: LikeResult
}

struct LikeResult: Codable {
    let id: String
    let likedByUser: Bool
}
