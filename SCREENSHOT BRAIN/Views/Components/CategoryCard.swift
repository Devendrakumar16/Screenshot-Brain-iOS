//
//  CategoryCard.swift
//  SCREENSHOT BRAIN
//
//  Created by Devendra Kumar on 17/08/26.
//

import SwiftUI

struct CategoryCard: View {

    let category: ScreenshotCategories
    let count: Int

    var body: some View {

        VStack(spacing: 8) {

            Image(systemName: category.icon)
                .font(.title2)
                .foregroundStyle(category.color)

            Text(category.rawValue)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(AppTheme.primaryText)
                .lineLimit(1)

            Text("\(count)")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 85
        )
        .background(
            Color.white.opacity(0.65)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 18)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(
                    Color.white.opacity(0.7),
                    lineWidth: 1
                )
        }
    }
}
