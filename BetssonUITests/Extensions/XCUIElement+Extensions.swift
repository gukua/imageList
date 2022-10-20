//
//  XCUIElement+Extensions.swift
//  BetssonUITests
//
//  Created by Adrian Krzyżowski on 20/10/2022.
//


import XCTest

@discardableResult
func with<T>(_ element: @autoclosure () -> T, _ closure: (T) throws -> Void = { _ in }) rethrows -> T {
    let xcElement = element()
    try closure(xcElement)
    return xcElement
}

extension XCUIElement {
    @discardableResult
    func waitForElementToAppear(timeout: TimeInterval = 5) -> Bool {
        let predicate = NSPredicate(format: "exists == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)

        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
}

