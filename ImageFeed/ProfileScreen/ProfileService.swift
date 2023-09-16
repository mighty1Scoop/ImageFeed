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
    let lastName: String?
    let bio: String?
    
//    enum CodingKeys: String, CodingKey {
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case username, bio
//    }
    
}

final class ProfileService {
    static let shared = ProfileService()
    private(set) var profile: Profile?
    private var lastToken: String = ""
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    private init() { }
    
    func fetchProfile(authToken: String, completion: @escaping (Result<Profile?, Error>) -> Void) {
        assert(Thread.isMainThread)
        if profile != nil { return }
        task?.cancel()
        
        guard let request = makeHTTPReqeust() else { return }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let body):
                profile = Profile(
                    username: body.username,
                    bio: body.bio ?? "",
                    firstName: body.firstName,
                    lastName: body.lastName ?? ""
                )
                
                completion(.success(profile))
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
}

extension ProfileService {
    func makeHTTPReqeust() -> URLRequest? {
        URLRequest.makeHTTPRequest(path: "/me", httpMethod: .GET)
    }
}
