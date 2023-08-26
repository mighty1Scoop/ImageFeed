//
//  ProfileImageResponseModel.swift.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 26.08.2023.
//

import Foundation

struct ProfileImageResponseModel: Decodable {
    let profileImages: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case profileImages = "profile_image"
    }
}

struct ProfileImage: Decodable {
    let small: String
    let medium: String
    let large: String
}
