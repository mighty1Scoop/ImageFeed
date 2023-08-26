//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 20.08.2023.
//

import Foundation

struct ProfileResult: Decodable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case username, bio
    }
    
}

final class ProfileService {
    static let shared = ProfileService()
    private(set) var profile: Profile?
    private var lastToken: String = ""
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    
    func fetchProfile(authToken: String, completion: @escaping (Result<Profile?, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastToken == authToken { return }
        task?.cancel()
        lastToken = authToken
        
        var request = UnsplashApiRoutes.selfProfileRequest
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let task = object(for: request) { result in
            switch result {
            case .success(let body):
                print("❇️", body)
                self.profile = Profile(
                    username: body.username,
                    bio: body.bio,
                    firstName: body.firstName,
                    lastName: body.lastName
                )
                completion(.success(self.profile))
            case .failure(let error):
                print("🔴 \(error)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
}

private extension ProfileService {
    func object(
        for request: URLRequest,
        completion: @escaping (Result<ProfileResult, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<ProfileResult, Error> in
                Result {
                    try decoder.decode(ProfileResult.self, from: data)
                }
            }
            completion(response)
        }
    }
}
