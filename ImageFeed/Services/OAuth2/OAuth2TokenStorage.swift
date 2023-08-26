//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 08.08.2023.
//

import Foundation

    final class OAuth2TokenStorage {
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case accessToken
    }
    
    var token: String? {
        get {
            userDefaults.string(forKey: Keys.accessToken.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.accessToken.rawValue)
        }
    }
    
}
