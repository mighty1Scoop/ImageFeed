//
//  ViewController.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 29.06.2023.
//

import UIKit

protocol ImagesViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol! { get set }
    func insertRows(oldCount: Int, newCount: Int)
    func cellIndexPath(for cell: UITableViewCell) -> IndexPath?
    func reloadRows(at indexPath: [IndexPath])
}

final class ImagesViewController: UIViewController {
    // MARK: - Properties
    
    var presenter: ImagesListPresenterProtocol!
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Private properties
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    // MARK: - UIStatusBarStyle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        updateTableViewObserver()
        presenter.fetchPhotosNextPage()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            if
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            {
                let imageUrl = presenter.photos[indexPath.row]
                viewController.fullScreenImageURL = imageUrl.largeImageURL
            } else {
                super.prepare(for: segue, sender: sender)
            }
        }
    }
    
    // MARK: - Private Properties
    
    private func configureTableView() {
        UIBlockingProgressHUD.show()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    private func updateTableViewObserver() {
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { _ in
            self.presenter.updateTableViewAnimated()
            UIBlockingProgressHUD.dismiss()
        }
    }
}

// MARK: - UITableViewDelegate
extension ImagesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == presenter.photos.count {
            presenter.fetchPhotosNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = presenter.photos[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
}

// MARK: - UITableViewDataSource
extension ImagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        imageListCell.delegate = presenter
        imageListCell.configure(with: presenter.photos[indexPath.row]) { result in
            switch result {
            case.success(_):
                tableView.reloadRows(at: [indexPath], with: .fade)
                print(indexPath.row)
            case .failure(_):
                print("❤️")
            }
        }
        return imageListCell
    }
}

// MARK: - ImagesViewControllerProtocol
extension ImagesViewController: ImagesViewControllerProtocol {
    func insertRows(oldCount: Int, newCount: Int) {
        tableView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map{ i in
                IndexPath(row: i, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .fade)
        } completion: { _ in }
    }
    
    func cellIndexPath(for cell: UITableViewCell) -> IndexPath? {
        tableView.indexPath(for: cell)
    }
    
    func reloadRows(at indexPath: [IndexPath]) {
        tableView.reloadRows(at: indexPath, with: .none)
    }
}
