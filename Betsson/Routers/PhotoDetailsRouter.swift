//
//  PhotoDetailsRouter.swift
//  Betsson
//
//  Created by Adrian Krzyżowski on 20/10/2022.
//

import UIKit

protocol PhotoDetailsRouter {
    func navigateToPhotoDetails(on: UINavigationController, photo: Photo)
}

final class PhotoDetailsRouterImplementation: PhotoDetailsRouter {
    func navigateToPhotoDetails(on: UINavigationController, photo: Photo) {
        on.pushViewController(PhotoDetailsViewController(photo: photo), animated: true)
    }
}
