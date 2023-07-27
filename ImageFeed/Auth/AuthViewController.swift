//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 27.07.2023.
//

import UIKit

final class AuthViewController: UIViewController {
    
    private let logoImage = UIImageView()
    private let signInButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

extension AuthViewController {
    private func setUp() {
        configureView()
        configureLogoImage()
        configureButton()
        configureBackButton()
    }
    
    private func configureView() {
        view.backgroundColor = .ypBlack
    }
    
    private func configureLogoImage() {
        view.addSubview(logoImage)
        
        let image = UIImage(named: "auth_screen_logo") ?? UIImage()
        logoImage.image = image
        
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureButton() {
        view.addSubview(signInButton)
        
        signInButton.setTitle("Войти", for: .normal)
        signInButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        signInButton.tintColor = .ypBlack
        signInButton.backgroundColor = .ypWhite
        signInButton.layer.cornerRadius = 16
        signInButton.layer.masksToBounds = true
        
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInButton.heightAnchor.constraint(equalToConstant: 48),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            signInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
        ])
        
        signInButton.addTarget(self, action: #selector(didTappedLogInButton), for: .touchUpInside)
    }
    
    func configureBackButton() {
        let image = UIImage(named: "nav_back_button_black") ?? UIImage()
        navigationController?.navigationBar.backIndicatorImage = image
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
        navigationController?.navigationBar.backItem?.title = ""
    }
    
    @objc private func didTappedLogInButton(_ sender: UIButton) {
        navigationController?.pushViewController(WebViewController(), animated: true)
    }
}

