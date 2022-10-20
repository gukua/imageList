//
//  ViewController.swift
//  Betsson
//
//  Created by Adrian Krzyżowski on 19/10/2022.
//

import UIKit

final class PhotoListViewController: UICollectionViewController {
    private let cellReuseIdentifier = "PhotoCell"
    private let photoService = PhotoServiceImplementation()
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    private var currentPage = 1
    private var photos = [Photo]()

    private lazy var router = PhotoDetailsRouterImplementation()
    private lazy var alertPresenter: AlertPresenter = {
        AlertPresenterImplementation(viewController: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        photoService.delegate = self
        title = "Photo list"
        loadPhotosPage()
    }

    private func loadPhotosPage() {
        Task {
            if let newPhotos = await photoService.fetchPhotos(page: currentPage) {
                photos.append(contentsOf: newPhotos)
                currentPage += 1
                self.collectionView.reloadData()
            }
        }
    }
}

extension PhotoListViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellReuseIdentifier,
            for: indexPath
        ) as! PhotoCell
        let photo = photos[indexPath.row]
        cell.backgroundColor = .gray
        Task {
            cell.imageView.image = UIImage(data: await photoService.downloadPhoto(photoId: photo.id, type: .thumbnail))
        }
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 {
            Task {
                if let newPhotos = await photoService.fetchPhotos(page: currentPage) {
                    currentPage += 1
                    photos.append(contentsOf: newPhotos)
                    collectionView.reloadData()
                }
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let navigationController {
            self.router.navigateToPhotoDetails(on: navigationController, photo: photos[indexPath.row])
        }
    }
}

extension PhotoListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension PhotoListViewController: PhotoServiceDelegate {
    func didFailDownloadPhotoList(in service: PhotoService) {
        alertPresenter.showRetry(message: "Failed to load photo list!") {
            self.loadPhotosPage()
        }
    }
}
