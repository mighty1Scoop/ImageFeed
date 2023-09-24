//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 23.09.2023.
//

import Foundation

protocol ImagesListPresenterProtocol: AnyObject, ImagesListCellDelegate {
    var view: ImagesViewControllerProtocol? { get set }
    var photos: [Photo] { get }
    func fetchPhotosNextPage()
    func updateTableView()
}

final class ImagesListPresenter: ImagesListPresenterProtocol {

    // MARK: - Properties
    
    weak var view: ImagesViewControllerProtocol?
    private (set) var photos: [Photo] = []
    
    // MARK: - Private Properties
    
    private let imageListService: ImageListServiceProtocol
    
    // MARK: - Public Methods
    
    init(imageListService: ImageListServiceProtocol = ImagesListService.shared) {
        self.imageListService = imageListService
    }
    
    func fetchPhotosNextPage() {
        imageListService.fetchPhotosNextPage()
    }
    
    func updateTableView() {
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        photos = imageListService.photos
        
        if oldCount != newCount {
            view?.insertRows(oldCount: oldCount, newCount: newCount)
        }
    }
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = view?.cellIndexPath(for: cell) else { return }
        let photo = self.photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imageListService.changeLike(
            photoId: photo.id,
            isLike: !photo.isLiked
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success():
                self.photos = imageListService.photos
                cell.updateLikeImage()
                view?.reloadRows(at: [indexPath])
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                print("\(error)")
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
}
