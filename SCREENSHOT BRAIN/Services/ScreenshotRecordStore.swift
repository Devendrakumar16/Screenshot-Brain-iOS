//
//  ScreenshotRecordStore.swift
//  SCREENSHOT BRAIN
//
//  Created by Devendra Kumar on 18/08/26.
//

import Foundation
import SwiftData

actor ScreenshotRecordStore {
    private let modelContainer: ModelContainer

    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }

    func loadMetadataByAssetIdentifier() throws -> [String: ScreenshotMetadata] {
        let context = ModelContext(modelContainer)
        let records = try context.fetch(
            FetchDescriptor<ScreenshotRecord>()
        )

        return Dictionary(
            uniqueKeysWithValues: records.map { record in
                (
                    record.assetIdentifier,
                    ScreenshotMetadata(
                        assetIdentifier: record.assetIdentifier,
                        extractedText: record.extractedText,
                        category: ScreenshotCategories(
                            rawValue: record.category
                        ) ?? .other
                    )
                )
            }
        )
    }

    func save(
        metadata: ScreenshotMetadata
    ) throws {
        let context = ModelContext(modelContainer)
        let assetIdentifier = metadata.assetIdentifier

        var descriptor = FetchDescriptor<ScreenshotRecord>(
            predicate: #Predicate { record in
                record.assetIdentifier == assetIdentifier
            }
        )
        descriptor.fetchLimit = 1

        if let existingRecord = try context.fetch(descriptor).first {
            existingRecord.extractedText = metadata.extractedText
            existingRecord.category = metadata.category.rawValue
        } else {
            let record = ScreenshotRecord(
                assetIdentifier: metadata.assetIdentifier,
                extractedText: metadata.extractedText,
                category: metadata.category.rawValue
            )

            context.insert(record)
        }

        try context.save()
    }
}
