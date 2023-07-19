//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 17.07.2023.
//

import UIKit


final class ProfileViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet private weak var profileImage: UIImageView!
    @IBOutlet private weak var exitButton: UIButton!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var nicknameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    //MARK: - Private properties
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - IBActions
    @IBAction func exitButtonTapped(_ sender: Any) {
    }
    
}
