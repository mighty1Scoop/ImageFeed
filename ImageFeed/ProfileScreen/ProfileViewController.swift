//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 17.07.2023.
//

import UIKit
import Kingfisher


final class ProfileViewController: UIViewController {
    //MARK: - Private arguments
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    //MARK: - UIElements
    private let mainContainer = UIStackView()
    
    private let headerContainer = UIStackView()
    private let profileImage = UIImageView()
    private let exitButton = UIButton()
    
    private let nameLabel = UILabel()
    private let nicknameLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    //MARK: - Status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let profile = profileService.profile else { return }
        setUp(with: profile)
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.DidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self else { return }
            self.updateAvatar(notification: notification)
        }
        if let url = profileImageService.avatarURL {
            updateAvatar(url: url)
        }
    }
    
    @objc
    private func updateAvatar(notification: Notification) {
        guard
            isViewLoaded,
            let userInfo = notification.userInfo,
            let profileImageURL = userInfo["URL"] as? String,
            let url = URL(string: profileImageURL)
        else { return }
        updateAvatar(url: url)
    }
}

//MARK: ConfigureUI
private extension ProfileViewController {
    func setUp(with profile: Profile) {
        view.backgroundColor = .ypBlack
        
        let mainContainerViews: [UIView] = [headerContainer, nameLabel, nicknameLabel,descriptionLabel]
        let headerContainerViews: [UIView] =
        [profileImage, exitButton]
        
        mainContainerViews.forEach {
            mainContainer.addArrangedSubview($0)
        }
        headerContainerViews.forEach{
            headerContainer.addArrangedSubview($0)
        }
        
        configureMainContainer()
        configureHeaderContatiner()
        configureProfileImage()
        configureExitButton()
        
        configureNameLabel(with: profile.name)
        configureNicknameLabel(with: profile.loginName)
        configureDescriptionLabel(with: profile.bio)

    }
    
    private func updateAvatar(url: URL) {
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        profileImage.kf.indicatorType = .activity
        profileImage.kf.setImage(with: url, options: [.processor(processor)])
        profileImage.layer.cornerRadius = 35
        profileImage.layer.masksToBounds = true
    }

    func configureMainContainer() {
        view.addSubview(mainContainer)
        
        mainContainer.axis = .vertical
        mainContainer.distribution = .fill
        mainContainer.alignment = .fill
        mainContainer.spacing = 8
        
        mainContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                mainContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                mainContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                mainContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
            ]
        )
    }
    
    func configureHeaderContatiner() {
        headerContainer.axis = .horizontal
        headerContainer.distribution = .equalSpacing
        headerContainer.alignment = .center
        headerContainer.spacing = 0
        
    }
    
    func configureProfileImage() {
        let image = UIImage(named: "Stub") ?? UIImage(systemName: "person.crop.circle.fill")!
        profileImage.image = image
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                profileImage.widthAnchor.constraint(equalToConstant: 70),
                profileImage.heightAnchor.constraint(equalToConstant: 70)
            ]
        )
        
    }
    
    func configureExitButton() {
        let exitButtonImage = UIImage(named: "ExitImage")
        exitButton.setImage(exitButtonImage, for: .normal)
        
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                exitButton.widthAnchor.constraint(equalToConstant: 44),
                exitButton.heightAnchor.constraint(equalToConstant: 44)
            ]
        )
    }
    
    func configureNameLabel(with name: String) {
        nameLabel.text = name
        nameLabel.textColor = .ypWhite
        nameLabel.font = .boldSystemFont(ofSize: 23)
    }
    
    func configureNicknameLabel(with nickname: String) {
        nicknameLabel.text = nickname
        nicknameLabel.textColor = .ypGray
        nicknameLabel.font = .systemFont(ofSize: 13)
    }
    
    func configureDescriptionLabel(with description: String) {
        descriptionLabel.text = description
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.font = .systemFont(ofSize: 13)
    }
}

