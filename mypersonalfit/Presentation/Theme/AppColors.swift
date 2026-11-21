//
//  AppColors.swift
//  mypersonalfit
//

import SwiftUI

extension Color {
    init(hex: UInt32) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: 1
        )
    }
}

/// Design tokens taken from the FitApp Mock in Figma.
enum AppColors {
    static let background = Color(hex: 0xF2EFE9)
    static let surface = Color(hex: 0xFCFBF8)
    static let textPrimary = Color(hex: 0x22262C)
    static let textSecondary = Color(hex: 0x777B82)
    static let accent = Color(hex: 0xD9FF43)
}
