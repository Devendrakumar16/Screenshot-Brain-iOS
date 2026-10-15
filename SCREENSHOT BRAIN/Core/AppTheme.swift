//
//  AppTheme.swift
//  SCREENSHOT BRAIN
//
//  Created by Devendra Kumar on 17/08/26.
//


import SwiftUI

enum AppTheme {

    static let backgroundGradient = LinearGradient(
        colors: [
            Color(hex: "E9E4FF"),
            Color(hex: "DDEBFF"),
            Color(hex: "FCE4F0")
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let primary = Color(hex: "6C63FF")
    static let secondary = Color(hex: "00BFA6")
    static let accent = Color(hex: "FF5C8A")
    
    static let card = Color.white.opacity(0.75)
    static let primaryText = Color(hex: "171725")
    static let secondaryText = Color(hex: "6F7185")
}

extension Color {
    init(hex: String) {
        let hex = hex
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")

        let value = UInt64(hex, radix: 16) ?? 0

        self.init(
            red: Double((value >> 16) & 0xFF) / 255,
            green: Double((value >> 8) & 0xFF) / 255,
            blue: Double(value & 0xFF) / 255
        )
    }
}
