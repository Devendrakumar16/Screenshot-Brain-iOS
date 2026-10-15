//
//  ScreenshotMetadata.swift
//  SCREENSHOT BRAIN
//
//  Created by Devendra Kumar on 17/08/26.
//


import Foundation

struct ScreenshotMetadata: Codable {

    let assetIdentifier: String
    let extractedText: String
    let category: ScreenshotCategories
}
