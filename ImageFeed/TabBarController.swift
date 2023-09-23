//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 15.09.2023.
//

import UIKit

class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let imagesVC = setupImagesListViewController()
        let profileVC = setupProfileController()
        
        self.viewControllers = [imagesVC, profileVC]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func setupImagesListViewController() -> ImagesViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let presenter = ImagesListPresenter()
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesViewController
        viewController.presenter = presenter
        presenter.view = viewController
        
        return viewController
    }
    
    private func setupProfileController() -> ProfileViewController {
        let presenter = ProfilePresenter()
        let viewController = ProfileViewController()
        viewController.presenter = presenter
        presenter.view = viewController
        viewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        return viewController
    }
}
