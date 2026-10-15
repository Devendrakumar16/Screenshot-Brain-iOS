//
//  ScreenshotCategorizer.swift
//  SCREENSHOT BRAIN
//
//  Created by Devendra Kumar on 17/08/26.
//


final class ScreenshotCategorizer {

    func categorize(text: String) -> ScreenshotCategories {

        let normalizedText = text.lowercased()

        var bestCategory = ScreenshotCategories.other
        var highestScore = 0

        for category in ScreenshotCategories.allCases {

            let score = category.keywords.reduce(0) { score, keyword in

                normalizedText.contains(keyword.lowercased())
                    ? score + 1
                    : score
            }

            if score > highestScore {
                highestScore = score
                bestCategory = category
            }
        }

        return bestCategory
    }
}
