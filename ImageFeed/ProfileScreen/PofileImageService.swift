//
//  PofileImageService.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 26.08.2023.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private (set) var avatarURL: URL?
    private let urlSession = URLSession.shared
    private let storage = OAuth2TokenStorage()
    private var task: URLSessionTask?

    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let token = storage.token else {
            assertionFailure("TOKEN IS NULL")
            return
        }
        
        let request = UnsplashApiRoutes.profileImageURLRequest(username: username, authToken: token)
        task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileImageResponseModel, Error>) in
            guard let self else { return }
            task = nil
            switch result {
            case .success(let body):
                let profileImageURL = body.profileImages.medium
                avatarURL = URL(string: profileImageURL)
                completion(.success(profileImageURL))
                
                NotificationCenter.default
                    .post(name: ProfileImageService.DidChangeNotification,
                          object: self,
                          userInfo: ["URL": profileImageURL]
                    )
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task?.resume()
    }
}
