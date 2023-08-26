//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 17.07.2023.
//

import UIKit


final class ProfileViewController: UIViewController {
    //MARK: - Private arguments
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver = NotificationCenter.default
    
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
        profileImageServiceObserver.addObserver(
                forName: ProfileImageService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                self.updateAvatar()
            }
    }
}

//MARK: ConfigureUI
private extension ProfileViewController {
    func setUp(with profile: Profile) {
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
    
    private func updateAvatar() {                                   // 8
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        // TODO [Sprint 11] Обновить аватар, используя Kingfisher
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
        profileImage.image = UIImage(named: "ProfileImage")
        profileImage.layer.cornerRadius = 61
        profileImage.mask?.clipsToBounds = true
        
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

