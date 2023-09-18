//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 12.07.2023.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    private var isLiked = false
    
    weak var delegate: ImagesListCellDelegate?
    
    @IBOutlet private weak var cellImage: UIImageView?
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var gradientImageView: UIImageView!
    
    override func layoutSubviews() {
        gradientImageView.layer.sublayers = nil
        setupGradient()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gradientImageView.layer.sublayers = nil
        cellImage?.kf.cancelDownloadTask()
    }
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
}

extension ImagesListCell {
    func configure(with photo: Photo, completion: @escaping (Result<Void, Error>) -> Void) {
        selectionStyle = .none
        configurateCellImage(with: photo, completion: completion)
        configurePhotoLikeButton(photo)
        configureDateLabel(with: photo)
    }
    
    func updateLikeImage() {
        likeButton.setImage(getLikeImage(), for: .normal)
    }
}

private extension ImagesListCell {
    func configurePhotoLikeButton(_ photo: Photo) {
        self.isLiked = photo.isLiked
        likeButton.setImage(getLikeImage(), for: .normal)
    }
    
    func configureDateLabel(with photo: Photo) {
        dateLabel.text = photo.createdAt ?? ""
    }
    
    func configurateCellImage(with photo: Photo, completion: @escaping (Result<Void, Error>) -> Void) {
        let placeholder = UIImage(named: "image_list_cell_stub") ?? UIImage()
        
        cellImage?.kf.indicatorType = .activity
        cellImage?.layer.cornerRadius = 16
        cellImage?.layer.masksToBounds = true
        cellImage?.image = placeholder
        
        guard let url = URL(string: photo.thumbImageURL) else {
            print("🔴 ERROR configure list cell")
            return
        }
        cellImage?.kf.setImage(with: url, placeholder: placeholder, completionHandler: (
            { result in
                switch result {
                case .success(_):
                    completion(.success(()))
                case.failure(let error):
                    completion(.failure(error))
                }
            }))
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
    
    func getLikeImage() -> UIImage? {
        return isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
    }
}
