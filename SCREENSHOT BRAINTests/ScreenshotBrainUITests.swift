//
//  ScreenshotBrainUITests.swift
//  SCREENSHOT BRAIN
//
//  Created by Devendra Kumar on 18/08/26.
//


import XCTest

final class ScreenshotBrainUITests: XCTestCase {

    func testAppLaunches() {

        let app = XCUIApplication()

        app.launch()

        XCTAssertTrue(
            app.exists
        )
    }
    
    func testSearchBarExists() {

        let app = XCUIApplication()

        app.launch()

        let searchField =
            app.textFields["Search"]

        XCTAssertTrue(
            searchField.exists
        )
    }
    
    func testSearchBarAcceptsText() {

        let app = XCUIApplication()

        app.launch()

        let searchField =
            app.textFields["Search"]

        XCTAssertTrue(
            searchField.exists
        )

        searchField.tap()

        searchField.typeText(
            "SwiftUI"
        )

        XCTAssertEqual(
            searchField.value as? String,
            "SwiftUI"
        )
    }
}
