//
//  ScreenshotCategorizerTests.swift
//  SCREENSHOT BRAINTests
//
//  Created by Devendra Kumar on 18/08/26.
//

import Foundation
import XCTest
@testable import SCREENSHOT_BRAIN

final class ScreenshotCategorizerTests:XCTestCase{
    private let categorizer = ScreenshotCategorizer()
    
    func testCodingScreenshot() {

           let text = """
           Xcode SwiftUI ContentView
           struct HomeView
           """

           let result = categorizer.categorize(
               text: text
           )

           XCTAssertEqual(
               result,
               .coding
           )
       }

       func testShoppingScreenshot() {

           let text = """
           Amazon
           Add to Cart
           ₹1,499
           Buy Now
           """

           let result = categorizer.categorize(
               text: text
           )

           XCTAssertEqual(
               result,
               .shopping
           )
       }

       func testTravelScreenshot() {

           let text = """
           Boarding Pass
           IndiGo
           Delhi → Mumbai
           """

           let result = categorizer.categorize(
               text: text
           )

           XCTAssertEqual(
               result,
               .travel
           )
       }

       func testFinanceScreenshot() {

           let text = """
           UPI Payment
           Transaction successful
           Bank account
           ₹500
           """

           let result = categorizer.categorize(
               text: text
           )

           XCTAssertEqual(
               result,
               .finance
           )
       }

       func testUnknownTextReturnsOther() {

           let text = """
           Hello World
           This is some random text
           """

           let result = categorizer.categorize(
               text: text
           )

           XCTAssertEqual(
               result,
               .other
           )
       }

       func testEmptyTextReturnsOther() {

           let result = categorizer.categorize(
               text: ""
           )

           XCTAssertEqual(
               result,
               .other
           )
       }
    
    func testCategorizationIsCaseInsensitive() {

        let text = """
        SWIFTUI
        XCODE
        DEVELOPER
        """

        let result = categorizer.categorize(
            text: text
        )

        XCTAssertEqual(
            result,
            .coding
        )
    }
   }

