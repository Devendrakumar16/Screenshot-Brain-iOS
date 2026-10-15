//
//  ScreenshotRecord.swift
//  SCREENSHOT BRAIN
//
//  Created by Devendra Kumar on 18/08/26.
//

import Foundation
import SwiftData

@Model
final class ScreenshotRecord {
    var assetIdentifier: String
    var extractedText: String
    var category: String
    var createdAt: Date

    init(
        assetIdentifier: String,
        extractedText: String,
        category: String,
        createdAt: Date = .now
    ) {
        self.assetIdentifier = assetIdentifier
        self.extractedText = extractedText
        self.category = category
        self.createdAt = createdAt
    }
}
