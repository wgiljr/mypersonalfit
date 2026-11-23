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

/// Color tokens from the FitApp Mock. Use these instead of literals or system colors.
///
/// The design is light-only for now. When a dark palette exists, switch these to
/// asset-catalog colors and every call site picks it up.
enum AppColors {
    // MARK: Backgrounds
    static let background = Color(hex: 0xF2EFE9)
    static let surface = Color(hex: 0xFCFBF8)

    // MARK: Text
    static let textPrimary = Color(hex: 0x22262C)
    static let textSecondary = Color(hex: 0x777B82)
    /// Pure black, used for emphasized labels (chips, card titles, buttons).
    static let textStrong = Color(hex: 0x000000)
    /// Text drawn over photos and dark scrims.
    static let textOnImage = Color(hex: 0xFFFFFF)
    /// Text drawn over `accent` fills.
    static let textOnAccent = Color(hex: 0x22262C)

    // MARK: Brand
    static let accent = Color(hex: 0xD9FF43)
    /// Darker lime for small indicators on light surfaces (e.g. active tab underline).
    static let accentStrong = Color(hex: 0xB9DD24)

    // MARK: Lines & overlays
    static let border = Color(hex: 0xD8D1C7)
    /// Dark scrim laid over photos so white text stays legible.
    static let imageScrim = Color.black.opacity(0.38)
}
