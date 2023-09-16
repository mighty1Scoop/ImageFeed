//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 20.08.2023.
//

import UIKit

protocol AlertPresenterProtocol: AnyObject {
    func showAlert(_ model: AlertModel)
}

final class AlertPresenter: AlertPresenterProtocol {
    private weak var viewController: UIViewController?
    
    var topVC: UIViewController {
           var topController: UIViewController = UIApplication.shared.mainKeyWindow!.rootViewController!
           while (topController.presentedViewController != nil) {
               topController = topController.presentedViewController!
           }
           return topController
       }
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func showAlert(_ model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
            )
        
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default) { _ in
            model.completion()
        }
        
        alert.addAction(action)
        topVC.present(alert, animated: true)
    }
}

extension UIApplication {
    var mainKeyWindow: UIWindow? {
        get {
            if #available(iOS 13, *) {
                return connectedScenes
                    .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                    .first { $0.isKeyWindow }
            } else {
                return keyWindow
            }
        }
    }
}
