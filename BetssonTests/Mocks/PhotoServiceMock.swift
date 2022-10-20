//
//  PhotoServiceMock.swift
//  BetssonTests
//
//  Created by Adrian Krzyżowski on 20/10/2022.
//

import Foundation
@testable import Betsson

class PhotoServiceMock: PhotoService {
    var dataStub = Data()
    var photoListStub = PhotoListStub().list

    func downloadPhoto(photoId: String, type: PhotoType) async -> Data {
        return dataStub
    }

    func fetchPhotos(page: Int) async -> [Photo]? {
        return photoListStub
    }
}
