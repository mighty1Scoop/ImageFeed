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
                rescaleAndCenterImageInScrollView(image: image)
                
            }
        }
    
    //MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        imageView.image = image
        rescaleAndCenterImageInScrollView(image: image)
        
    }
    
    //MARK: - IBActions
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton() {
        guard let image else { return }
        let share = UIActivityViewController(activityItems: [image], applicationActivities: .none)
        
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
    
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
