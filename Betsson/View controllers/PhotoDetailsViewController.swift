//
//  PhotoDetailsViewController.swift
//  Betsson
//
//  Created by Adrian Krzyżowski on 20/10/2022.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
    @IBOutlet private weak var idLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var sizeLabel: UILabel!
    @IBOutlet private weak var urlLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var segmentedControll: UISegmentedControl!
    @IBOutlet private weak var activityIndicatorContainer: UIView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private let photo: Photo
    private let photoService = PhotoServiceImplementation()
    private var originalImage: UIImage?
    private var bluredImage: UIImage?
    private var grayscaledImage: UIImage?
    private lazy var alertPresenter: AlertPresenter = {
        AlertPresenterImplementation(viewController: self)
    }()

    init(photo: Photo) {
        self.photo = photo
        super.init(nibName: "PhotoDetailsView", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        photoService.delegate = self
        configureView()
    }

    @IBAction private func changeSegment(_ sender: Any) {
        switch segmentedControll.selectedSegmentIndex {
        case 0:
            imageView.image = originalImage
        case 1:
            downloadPhotoForType(type: .blur)
        case 2:
            downloadPhotoForType(type: .grayscale)
        default:
            break
        }
    }

    private func downloadPhotoForType(type: PhotoType) {
        showActivityIndicator(true)
        switch type {
        case .original:
            guard let originalImage else {
                Task {
                    originalImage = UIImage(data: await photoService.downloadPhoto(photoId: photo.id, type: .original))
                    showActivityIndicator(false)
                    imageView.image = originalImage
                }
                break
            }
            imageView.image = originalImage
        case .grayscale:
            guard let grayscaledImage else {
                Task {
                    grayscaledImage = UIImage(data: await photoService.downloadPhoto(photoId: photo.id, type: .grayscale))
                    showActivityIndicator(false)
                    imageView.image = grayscaledImage
                }
                break
            }
            imageView.image = grayscaledImage
        case .blur:
            guard let bluredImage else {
                Task {
                    bluredImage = UIImage(data: await photoService.downloadPhoto(photoId: photo.id, type: .blur))
                    showActivityIndicator(false)
                    imageView.image = bluredImage
                }
                break
            }
            imageView.image = bluredImage
        default:
            break
        }
    }

    private func configureView() {
        idLabel.text = "ID: \(photo.id)"
        authorLabel.text = "Author: \(photo.author)"
        sizeLabel.text = "Original size: \(photo.width)x\(photo.height)"
        urlLabel.text = "URL: \(photo.url)"
        downloadPhotoForType(type: .original)
    }

    private func showActivityIndicator(_ show: Bool) {
        segmentedControll.isUserInteractionEnabled = !show
        activityIndicatorContainer.isHidden = !show
        show ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
}

extension PhotoDetailsViewController: PhotoServiceDelegate {
    func didFailDownloadPhoto(in service: PhotoService, photoId: String, type: PhotoType) {
        alertPresenter.showRetry(message: "Failed to load specific photo!") {
            self.downloadPhotoForType(type: type)
        }
    }
}
