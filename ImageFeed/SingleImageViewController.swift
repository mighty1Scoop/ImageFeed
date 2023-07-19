//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 19.07.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    //MARK: - Properties
    var image: UIImage! {
            didSet {
                guard isViewLoaded else { return } 
                imageView.image = image
            }
        }
    
    //MARK: - IBOutlets
    @IBOutlet private weak var imageView: UIImageView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
}
