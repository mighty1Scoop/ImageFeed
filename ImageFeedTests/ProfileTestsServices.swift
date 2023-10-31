//
//  Stubs.swift
//  ImageFeedTests
//
//  Created by Nikolay Kozlov on 23.09.2023.
//
@testable import ImageFeed
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var viewDidLoadIsCalled: Bool = false
    var view: ImageFeed.ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadIsCalled = true
    }
    
    func updateUserProfile(profile: ImageFeed.Profile?) {}
    
    func updateUserAvatar(imageURL: URL?) {}
}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var setupCalled = false
    var updateAvatarCalled = false
    
    var presenter: ImageFeed.ProfilePresenterProtocol?
    
    func setup(with profile: ImageFeed.Profile) {
        setupCalled = true
    }
    
    func updateAvatar(url: URL) {
        updateAvatarCalled = true
    }
}

final class ProfileServiceStub: ProfileServiceProtocol {
    var profile: Profile? = Profile(
        username: "name",
        bio: "bio",
        firstName: "firstName",
        lastName: "Lastname"
    )
    
    func fetchProfile(authToken: String, completion: @escaping (Result<ImageFeed.Profile?, Error>) -> Void) {
    }
}
final class ProfileImageServiceStub: ProfileImageServiceProtocol {
    var avatarURL = URL(string: "https://google.com")
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
    }
}
