//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 12.07.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    @IBOutlet private weak var cellImage: UIImageView?
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    
    static let reuseIdentifier = "ImagesListCell"
    
}


extension ImagesListCell {
    func configure(image: UIImage, date: String, isLiked: Bool) {
        cellImage?.image = image
        dateLabel.text = date
        
        cellImage?.layer.cornerRadius = 16
        cellImage?.layer.masksToBounds = true
        
        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
    }
}
