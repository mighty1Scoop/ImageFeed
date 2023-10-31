//
//  ProfileImageResponseModel.swift.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 26.08.2023.
//

import Foundation

struct ProfileImageResponseModel: Decodable {
    let profileImage: ProfileImageSizes

}

struct ProfileImageSizes: Decodable {
    let small: String
    let medium: String
    let large: String
}
