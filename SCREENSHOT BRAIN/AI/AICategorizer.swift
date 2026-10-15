//
//  AICategorizer.swift
//  SCREENSHOT BRAIN
//
//  Created by Devendra Kumar on 18/08/26.
//


import Foundation

final class AICategorizer {

    private let geminiService = GeminiService()

    func categorize(
        text: String
    ) async -> ScreenshotCategories {

        guard !text.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty else {

            return .other
        }

        do {

            let response =
                try await geminiService.categorize(
                    text: text
                )

            guard let category =
                    ScreenshotCategories(
                        rawValue: response
                    ) else {

                print(
                    "⚠️ Invalid AI category:",
                    response
                )

                return .other
            }

            print(
                "🤖 AI Category:",
                category.rawValue
            )

            return category

        } catch {

            print(
                "❌ AI categorization failed:",
                error.localizedDescription
            )

            return .other
        }
    }
}
