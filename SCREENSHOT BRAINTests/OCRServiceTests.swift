//
//  OCRServiceTests.swift
//  SCREENSHOT BRAIN
//
//  Created by Devendra Kumar on 18/08/26.
//


import XCTest
@testable import SCREENSHOT_BRAIN

final class OCRServiceTests: XCTestCase {

    func testOCRRecognizesText() async throws {

        let bundle = Bundle(
            for: Self.self
        )

        guard let url = bundle.url(
            forResource: "TestScreenshot",
            withExtension: "png"
        ) else {

            XCTFail(
                "TestScreenshot.png not found"
            )

            return
        }

        let data = try Data(contentsOf: url)

        guard let image = UIImage(data: data) else {

            XCTFail(
                "Could not create UIImage"
            )

            return
        }

        let service = OCRService()

        let text = await service.recognizeText(
            from: image
        )

        XCTAssertFalse(
            text.isEmpty
        )

        print("OCR RESULT:", text)
    }
}