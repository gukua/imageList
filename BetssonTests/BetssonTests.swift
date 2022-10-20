//
//  BetssonTests.swift
//  BetssonTests
//
//  Created by Adrian Krzyżowski on 19/10/2022.
//

import XCTest
@testable import Betsson

final class BetssonTests: XCTestCase {
    var sut: PhotoService!
    var photoListStub = PhotoListStub().list

    override func setUp() {
        super.setUp()
        sut = PhotoServiceMock()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testDownloadPhoto() throws {
        let expectation = expectation(description: "loginTests")

        Task {
            var result: Data?
            result = await sut.downloadPhoto(photoId: photoListStub.first!.id, type: .original)
            expectation.fulfill()

            XCTAssertNotNil(result)
        }

        waitForExpectations(timeout: 0.5)
    }

    func testFetchPhotoList() throws {
        let expectation = expectation(description: "loginTests")

        Task {
            var photos: [Photo]?
            photos = await sut.fetchPhotos(page: 1)
            expectation.fulfill()

            XCTAssertNotNil(photos)
            XCTAssertEqual(photos, photoListStub)
        }

        waitForExpectations(timeout: 0.5)
    }
}
