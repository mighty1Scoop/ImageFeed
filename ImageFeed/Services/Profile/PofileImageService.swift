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
    
    private (set) var avatarURL: String?
    private var lastUsername: String?
    private let urlSession = URLSession.shared
    private let storage = OAuth2TokenStorage()
    private var task: URLSessionTask?

    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastUsername == username { return }
        task?.cancel()
        lastUsername = username
        
        guard let token = storage.token else {
            assertionFailure("TOKEN IS NULL")
            return
        }
        
        let request = UnsplashApiRoutes.profileImageURLRequest(username: username, authToken: token)
        let task = object(for: request) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let body):
                let profileImageURL = body.profileImages.small
                avatarURL = profileImageURL
                completion(.success(profileImageURL))
                NotificationCenter.default
                    .post(name: ProfileImageService.DidChangeNotification,
                          object: self,
                          userInfo: ["URL": profileImageURL]
                    )
            case .failure(let error):
                print("ERROR")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

private extension ProfileImageService {
    func object(
        for request: URLRequest,
        completion: @escaping (Result<ProfileImageResponseModel, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<ProfileImageResponseModel, Error> in
                Result {
                    try decoder.decode(ProfileImageResponseModel.self, from: data)
                }
            }
            completion(response)
        }
    }
}
