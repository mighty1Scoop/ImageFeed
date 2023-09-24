//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Nikolay Kozlov on 24.09.2023.
//

@testable import ImageFeed
import XCTest

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var fetchPhotosCalled = false
    var view: ImageFeed.ImagesViewControllerProtocol?
    
    var photos: [ImageFeed.Photo] = []

    func fetchPhotosNextPage() {
        fetchPhotosCalled = true
    }
    
    func updateTableView() {
    }
    
    func imageListCellDidTapLike(_ cell: ImageFeed.ImagesListCell) {
    }
    
    
}

final class ImagesListViewControllerSpy: ImagesViewControllerProtocol {
    var insertRowsCalled = false
    var presenter: ImageFeed.ImagesListPresenterProtocol!
    
    func insertRows(oldCount: Int, newCount: Int) {
        insertRowsCalled = true
    }
    
    func cellIndexPath(for cell: UITableViewCell) -> IndexPath? {
        return nil
    }
    
    func reloadRows(at indexPath: [IndexPath]) {
        
    }
}

final class ImageListServiceStub: ImageListServiceProtocol {
    var photos: [ImageFeed.Photo] = []
    
    static let shared = ImageListServiceStub()
    
    private init() {}
    
    func fetchPhotosNextPage() {
        let photo = generatePhoto()
        photos.append(photo)
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        if let index = self.photos.firstIndex(where: {$0.id == photoId}) {
            let photo = self.photos[index]
            let newPhoto = Photo(
                id: photo.id,
                size: photo.size,
                createdAt: photo.createdAt,
                welcomeDescription: photo.welcomeDescription,
                thumbImageURL: photo.thumbImageURL,
                largeImageURL: photo.largeImageURL,
                isLiked: !photo.isLiked
            )
            self.photos[index] = newPhoto
        }
    }
    
    private func generatePhoto() -> Photo {
        var photo = Photo(
            id: "\(UUID().uuidString)",
            size: CGSize(width: Double.random(in: 1...100), height: Double.random(in: 1...300)),
            createdAt: "2016-05-03T11:00:28-04:00",
            welcomeDescription: String.randomString(length: 40),
            thumbImageURL: "https://images.unsplash.com/face-springmorning.jpg?q=75&fm=jpg&w=200&fit=max",
            largeImageURL: "https://images.unsplash.com/face-springmorning.jpg?q=75&fm=jpg",
            isLiked: false)
        
        return photo
    }
}



// MARK: - TESTS
final class ImagesListTests: XCTestCase {
    func testViewControllerCalledFetchNextPhotoOnStartup() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.fetchPhotosCalled)
    }
    
    func testInsertRowsViewControllerCalledWhenNewPhotosFetched() {
        let service = ImageListServiceStub.shared
        let vc = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenter(imageListService: service)
        vc.presenter = presenter
        presenter.view = vc
        
        presenter.updateTableView()
        
        XCTAssertFalse(vc.insertRowsCalled)
        
        service.fetchPhotosNextPage()
        presenter.updateTableView()
        
        XCTAssertTrue(vc.insertRowsCalled)
    }
}
