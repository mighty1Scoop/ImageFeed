//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 12.07.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet private weak var cellImage: UIImageView?
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private var gradientImageView: UIImageView!
    
    override func layoutSubviews() {
        gradientImageView.layer.sublayers = nil
        setupGradient()
    }
    
    override func prepareForReuse() {
        gradientImageView.layer.sublayers = nil
    }
    
}

extension ImagesListCell {
    func configure(image: UIImage, date: String, isLiked: Bool) {
        selectionStyle = .none
        
        cellImage?.image = image
        dateLabel.text = date
        
        cellImage?.layer.cornerRadius = 16
        cellImage?.layer.masksToBounds = true
        
        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
    }
    
    func setupGradient() {
        let height = gradientImageView.bounds.height
        let width = gradientImageView.bounds.width
        
        let colorTop = UIColor.ypBlack.withAlphaComponent(0.0).cgColor
        let colorBottom = UIColor.ypBlack.withAlphaComponent(0.4).cgColor
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x:0, y:0, width: width, height: height)
        gradient.colors = [colorTop, colorBottom]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradientImageView.layer.addSublayer(gradient)
    }
}
