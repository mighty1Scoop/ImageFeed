//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 12.07.2023.
//

import UIKit
import Kingfisher

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
        super.prepareForReuse()
        gradientImageView.layer.sublayers = nil
        cellImage?.kf.cancelDownloadTask()
    }
    
}

extension ImagesListCell {
    func configure(with photo: Photo, completion: @escaping (Result<RetrieveImageResult, Error>) -> Void) {
        selectionStyle = .none
        configurateCellImage(with: photo.thumbImageURL, completion: completion)
        
        dateLabel.text = photo.createdAt ?? ""
        let likeImage = photo.isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
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

private extension ImagesListCell {
    func configurateCellImage(with stringUrl: String, completion: @escaping (Result<RetrieveImageResult, Error>) -> Void) {
        let placeholder = UIImage(named: "image_list_cell_stub") ?? UIImage()
        
        cellImage?.kf.indicatorType = .activity
        cellImage?.layer.cornerRadius = 16
        cellImage?.layer.masksToBounds = true
        cellImage?.image = placeholder
        
        guard let url = URL(string: stringUrl) else {
            print("🔴 ERROR configure list cell")
            return
        }
        cellImage?.kf.setImage(with: url, placeholder: placeholder, completionHandler: (
            { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case.failure(let error):
                completion(.failure(error))
            }
        }))
    }
}
