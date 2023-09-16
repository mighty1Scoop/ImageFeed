//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 08.08.2023.
//

import Foundation
import SwiftKeychainWrapper


final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private let keyChainWrapper = KeychainWrapper.standard
    
    private enum Keys: String {
        case accessToken
    }
    
    var token: String? {
        get {
            keyChainWrapper.string(forKey: Keys.accessToken.rawValue)
        }
        set {
            keyChainWrapper.set(newValue ?? "", forKey: Keys.accessToken.rawValue)
        }
    }
    
    func removeToken() {
        token = nil
        keyChainWrapper.removeObject(forKey: Keys.accessToken.rawValue)
    }
}
