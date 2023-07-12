//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 12.07.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    @IBOutlet var cellImage: UIImageView?
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    
    static let reuseIdentifier = "ImagesListCell"
    
    @IBAction func likeButtonTapped(_ sender: Any) {
    }
    
    
    
    
}
