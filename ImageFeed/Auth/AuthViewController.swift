//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 27.07.2023.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

class AuthViewController: UIViewController {
    private let showWebViewSegueIdentifier = "ShowWebView"
    
    weak var delegate: AuthViewControllerDelegate?
    
    //MARK: - IBOutlets
    @IBOutlet private weak var signInButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSignInButton()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(showWebViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}


extension AuthViewController {
    func configureSignInButton() {
        signInButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        signInButton.layer.cornerRadius = 16
        signInButton.layer.masksToBounds = true
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
