//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 19.07.2023.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    //MARK: - Properties
    private var image: UIImage?
    private var alertPresenter: AlertPresenterProtocol?
    
    var fullScreenImageURL: String?
    
    //MARK: - IBOutlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(viewController: self)
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showFullScreenImage()
    }
    
    //MARK: - IBActions
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton() {
        guard let image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: .none
        )
        
        present(share, animated: true)
    }
    
    //MARK: - Private methods
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func showFullScreenImage() {
        guard let url = URL(string: fullScreenImageURL ?? "") else { return }
        UIBlockingProgressHUD.show()
        imageView?.kf.setImage(with: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                UIBlockingProgressHUD.dismiss()
                self.image = imageResult.image
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showAlert()
            }
        }
    }
}


extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}


private extension SingleImageViewController {
    func showAlert() {
        let alertModel = AlertModel(
            title: "Что-то пошло не так",
            message: "Не удалось войти в систему",
            buttonText: "Повторить",
            completion: {
                self.showFullScreenImage()
            }
        )
        self.alertPresenter?.showAlert(alertModel)
    }
}
