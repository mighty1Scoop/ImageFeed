//
//  PhotoViewModel.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 16.09.2023.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: String?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
