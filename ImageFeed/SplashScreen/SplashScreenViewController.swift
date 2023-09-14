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
    
    private let oauth2Storage = OAuth2TokenStorage()
    private let oauth2Service = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var alertPresenter: AlertPresenterProtocol?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = oauth2Storage.token {
            profileService.fetchProfile(authToken: token) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let profile):
                    ProfileImageService.shared.fetchProfileImageURL(username: profile?.username ?? "") { _ in }
                    switchToTabBarController()
                case .failure(let error):
                    print("\(error)")
                }
            }
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}


extension SplashScreenViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)") }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashScreenViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        //CODE: ff8yAziK3kPhZWg
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self else { return }
            fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchAuthToken(code) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let authToken):
                self.fetchProfile(authToken)
                UIBlockingProgressHUD.dismiss()
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
                UIBlockingProgressHUD.dismiss()
                profileImageService.fetchProfileImageURL(username: profile?.username ?? "") { _ in }
                self.switchToTabBarController()
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
        
        alertPresenter?.showAlert(alertModel)
    }
}
