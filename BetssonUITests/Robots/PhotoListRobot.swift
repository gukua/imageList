//
//  PhotoListRobot.swift
//  BetssonUITests
//
//  Created by Adrian Krzyżowski on 20/10/2022.
//

import XCTest

@discardableResult
func photoList(app: XCUIApplication, closure: (PhotoListRobot) -> Void = { _ in }) -> PhotoListRobot {
    let robot = PhotoListRobot(app: app)
    closure(robot)
    return robot
}

class PhotoListRobot {
    let app: XCUIApplication
    init(app: XCUIApplication) {
        self.app = app
    }

    @discardableResult
    func photoListTitle(_ closure: (XCUIElement) -> Void = { _ in }) -> XCUIElement {
        with(app.navigationBars["Photo list"], closure)
    }

    @discardableResult
    func firstPhoto(_ closure: (XCUIElement) -> Void = { _ in }) -> XCUIElement {
        with(app.collectionViews.children(matching: .cell).element(boundBy: 0), closure)
    }

    @discardableResult
    func segmentedControll(_ closure: (XCUIElement) -> Void = { _ in }) -> XCUIElement {
        with(app.segmentedControls.buttons["Original"], closure)
    }
}
