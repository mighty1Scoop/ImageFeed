//
//  SplashScreenViewController.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 09.08.2023.
//

import UIKit
import ProgressHUD

class SplashScreenViewController: UIViewController {
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreenSegue"
    private let authViewControllerIdentifier = "AuthViewController"
    private let tabBarControllerIdentifier = "TabBarViewController"
    
    private let oauth2Storage = OAuth2TokenStorage()
    private let oauth2Service = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var alertPresenter: AlertPresenterProtocol?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private var logoImageView: UIImageView = {
        let logoImage = UIImage(named: "launch_screen_logo")
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        return logoImageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(viewController: self)
        setUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = oauth2Storage.token {
            UIBlockingProgressHUD.show()
            profileService.fetchProfile(authToken: token) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let profile):
                    ProfileImageService.shared.fetchProfileImageURL(username: profile?.username ?? "") { _ in }
                    switchToTabBarController()
                    UIBlockingProgressHUD.dismiss()
                case .failure(let error):
                    UIBlockingProgressHUD.dismiss()
                    showAlert()
                    print("\(error)")
                }
            }
        } else {
            showAuthViewController()
        }
    }
    
    private func showAuthViewController() {
        let viewController = UIStoryboard(
            name: "Main",
            bundle: .main
        ).instantiateViewController(identifier: authViewControllerIdentifier)
        
        guard let authViewController = viewController as? AuthViewController else { return }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration")
        }
        
        let tabBarController = UIStoryboard(
            name: "Main",
            bundle: .main
        ).instantiateViewController(withIdentifier: tabBarControllerIdentifier)
        window.rootViewController = tabBarController
    }
}


extension SplashScreenViewController {
    private func setUp() {
        view.backgroundColor = .ypBackground
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        )
    }
    
}

extension SplashScreenViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        fetchOAuthToken(code)
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchAuthToken(code) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let authToken):
                self.fetchProfile(authToken)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                showAlert()
                break
            }
        }
    }
    
    private func fetchProfile(_ authToken: String) {
        profileService.fetchProfile(authToken: authToken) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                profileImageService.fetchProfileImageURL(
                    username: profile?.username ?? ""
                ) { _ in }
                self.switchToTabBarController()
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                showAlert()
            }
        }
    }
}


private extension SplashScreenViewController {
    func showAlert() {
        let alertModel = AlertModel(
            title: "Что-то пошло не так",
            message: "Не удалось войти в систему",
            buttonText: "Ок",
            completion: {}
        )
        
        self.alertPresenter?.showAlert(alertModel)
    }
}
