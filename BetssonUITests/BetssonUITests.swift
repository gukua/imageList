//
//  BetssonUITests.swift
//  BetssonUITests
//
//  Created by Adrian Krzyżowski on 19/10/2022.
//

import XCTest

final class BetssonUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        super.tearDown()
        app = nil
    }

    func testSearchListVisible() throws {
        photoList(app: app).photoListTitle().waitForElementToAppear()
    }

    func testFavouritesViewVisible() throws {
        photoList(app: app) {
            $0.firstPhoto {
                $0.waitForElementToAppear()
                $0.tap()
            }
            $0.segmentedControll().waitForElementToAppear()
        }
    }
}

