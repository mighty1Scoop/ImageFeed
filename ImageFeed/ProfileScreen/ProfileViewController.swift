//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 17.07.2023.
//

import UIKit


final class ProfileViewController: UIViewController {
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
        setUp()
        
    }
    
    private func setUp() {
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
        
        configureNameLabel()
        configureNicknameLabel()
        configureDescriptionLabel()
    }
    
}
//MARK: ConfigureUI
private extension ProfileViewController {
    
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
    
    func configureNameLabel() {
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .ypWhite
        nameLabel.font = .boldSystemFont(ofSize: 23)
    }
    
    func configureNicknameLabel() {
        nicknameLabel.text = "@ekaterina_novikova"
        nicknameLabel.textColor = .ypGray
        nicknameLabel.font = .systemFont(ofSize: 13)
    }
    
    func configureDescriptionLabel() {
        descriptionLabel.text = "Hello World!"
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.font = .systemFont(ofSize: 13)
    }
}

