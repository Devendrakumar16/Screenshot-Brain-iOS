//
//  ScreenshotMetadataTests.swift
//  SCREENSHOT BRAIN
//
//  Created by Devendra Kumar on 18/08/26.
//


import XCTest
@testable import SCREENSHOT_BRAIN

final class ScreenshotMetadataTests: XCTestCase {

    func testMetadataEncodingAndDecoding() throws {

        let metadata = ScreenshotMetadata(
            assetIdentifier: "ABC123",
            extractedText: "SwiftUI Xcode",
            category: .coding
        )

        let data = try JSONEncoder().encode(
            metadata
        )

        let decoded = try JSONDecoder().decode(
            ScreenshotMetadata.self,
            from: data
        )

        XCTAssertEqual(
            decoded.assetIdentifier,
            "ABC123"
        )

        XCTAssertEqual(
            decoded.extractedText,
            "SwiftUI Xcode"
        )

        XCTAssertEqual(
            decoded.category,
            .coding
        )
    }
}