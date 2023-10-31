//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 23.09.2023.
//

import Foundation

// MARK: - Protocol
protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func updateUserProfile(profile: Profile?)
    func updateUserAvatar(imageURL: URL?)
}

// MARK: - Class
final class ProfilePresenter: ProfilePresenterProtocol {
    // MARK: - Properties
    
    weak var view: ProfileViewControllerProtocol?
    
    // MARK: - Private Properties
    
    private let profileService: ProfileServiceProtocol
    private let profileImageService: ProfileImageServiceProtocol
    
    // MARK: - Init
    
    init(
        profileService: ProfileServiceProtocol = ProfileService.shared,
        profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared
    ) {
        self.profileService = profileService
        self.profileImageService = profileImageService
    }
    
    // MARK: - Public Methods
    
    func viewDidLoad() {
        let profile = getUserProfileData()
        let url = userAvatarURL()
        
        updateUserProfile(profile: profile)
        updateUserAvatar(imageURL: url)
    }
    
    func updateUserProfile(profile: Profile?) {
        guard let profile else {
            assertionFailure("PROFILE IS NIL")
            return
        }
        view?.setup(with: profile)
    }
    
    func updateUserAvatar(imageURL: URL?) {
        guard let imageURL else {
            assertionFailure("CANT CREATE URL FOR AVATAR")
            return
        }
        view?.updateAvatar(url: imageURL)
    }
    
    // MARK: - Private Methods

    private func getUserProfileData() -> Profile? {
        return profileService.profile
    }
    
    private func userAvatarURL() -> URL? {
        return profileImageService.avatarURL
    }
    
    
}
