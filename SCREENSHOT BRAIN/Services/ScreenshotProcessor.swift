//
//  ScreenshotProcessor.swift
//  SCREENSHOT BRAIN
//
//  Created by Devendra Kumar on 17/08/26.
//

import Photos
import UIKit

final class ScreenshotProcessor {

    private let ocrService = OCRService()
    private let categorizer = AICategorizer()

    func process(
        asset: PHAsset
    ) async -> ScreenshotMetadata? {

        guard let image = await getFullResolutionImage(
            asset: asset
        ) else {
            return nil
        }

        let text = await ocrService.recognizeText(
            from: image
        )

        let category = await categorizer.categorize(
            text: text
        )

        print("━━━━━━━━━━━━━━━━━━━━")
        print("🖼️ Asset:", asset.localIdentifier)
        print("📝 OCR:", text)
        print("📂 Category:", category.rawValue)
        print("━━━━━━━━━━━━━━━━━━━━")

        return ScreenshotMetadata(
            assetIdentifier: asset.localIdentifier,
            extractedText: text,
            category: category
        )
    }

    private func getFullResolutionImage(
        asset: PHAsset
    ) async -> UIImage? {

        await withCheckedContinuation { continuation in

            let options = PHImageRequestOptions()

            options.isNetworkAccessAllowed = true
            options.deliveryMode = .highQualityFormat
            options.resizeMode = .none

            PHImageManager.default()
                .requestImageDataAndOrientation(
                    for: asset,
                    options: options
                ) { data, _, _, info in

                    guard let data else {
                        print("❌ Failed to load original image")
                        print("Info:", info ?? [:])

                        continuation.resume(returning: nil)
                        return
                    }

                    guard let image = UIImage(data: data) else {
                        continuation.resume(returning: nil)
                        return
                    }

                    continuation.resume(
                        returning: image
                    )
                }
        }
    }
}
