//
//  PhotoService.swift
//  Betsson
//
//  Created by Adrian Krzyżowski on 19/10/2022.
//

import Foundation

protocol PhotoService {
    func fetchPhotos(page: Int) async -> [Photo]?
    func downloadPhoto(photoId: String, type: PhotoType) async -> Data
}

protocol PhotoServiceDelegate: AnyObject {
    func didFailDownloadPhotoList(in service: PhotoService)
    func didFailDownloadPhoto(in service: PhotoService, photoId: String, type: PhotoType)
}

extension PhotoServiceDelegate {
    func didFailDownloadPhotoList(in service: PhotoService) {}
    func didFailDownloadPhoto(in service: PhotoService, photoId: String, type: PhotoType) {}
}

enum PhotoType {
    case thumbnail
    case original
    case blur
    case grayscale
}

final class PhotoServiceImplementation: PhotoService {
    weak var delegate: PhotoServiceDelegate?

    @Published var isLoadingData = false

    private let jsonDecoder = JSONDecoder()
    private let urlSession = URLSession.shared

    init() {
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func fetchPhotos(page: Int) async -> [Photo]? {
        guard let url = URL(string: "https://picsum.photos/v2/list?page=\(page)") else { return nil }
        do {
            let (data, _) = try await urlSession.data(from: url)
            return try jsonDecoder.decode([Photo].self, from: data)
        } catch {
            delegate?.didFailDownloadPhotoList(in: self)
        }
        return nil
    }

    func downloadPhoto(photoId: String, type: PhotoType) async -> Data {
        isLoadingData = true
        var photoData = Data()
        var url: URL
        switch type {
        case .thumbnail:
            url = URL(string: "https://picsum.photos/id/\(photoId)/100")!
        case .original:
            url = URL(string: "https://picsum.photos/id/\(photoId)/300")!
        case .blur:
            url = URL(string: "https://picsum.photos/id/\(photoId)/300?blur")!
        case .grayscale:
            url = URL(string: "https://picsum.photos/id/\(photoId)/300?grayscale")!
        }
        do {
            photoData = try await urlSession.data(from: url).0
            isLoadingData = false
            return photoData
        } catch {
            isLoadingData = false
            delegate?.didFailDownloadPhoto(in: self, photoId: photoId, type: type)
        }
        return photoData
    }
}
