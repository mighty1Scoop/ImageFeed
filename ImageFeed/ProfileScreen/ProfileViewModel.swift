//
//  Profile.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 20.08.2023.
//

import Foundation

struct Profile {
    let username: String
    var loginName: String {
        return "@\(username)"
    }
    let bio: String
    let firstName: String
    let lastName: String
    var name: String {
        return "\(firstName) \(lastName)"
    }
}
