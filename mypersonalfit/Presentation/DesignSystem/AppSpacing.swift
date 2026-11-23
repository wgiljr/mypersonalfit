//
//  AppSpacing.swift
//  mypersonalfit
//

import CoreGraphics

/// Spacing scale (points) for padding, stack spacing and gaps.
/// Pick the closest token rather than introducing a one-off number.
enum AppSpacing {
    static let xxs: CGFloat = 2
    static let xs: CGFloat = 5
    /// Tight vertical padding inside small pills such as badges.
    static let compact: CGFloat = 6
    static let sm: CGFloat = 8
    static let md: CGFloat = 10
    static let lg: CGFloat = 12
    static let xl: CGFloat = 14
    static let xxl: CGFloat = 16
    static let xxxl: CGFloat = 20

    /// Horizontal inset of every screen's content.
    static let screenHorizontal: CGFloat = xxxl
    /// Vertical gap between sections on a screen.
    static let sectionGap: CGFloat = xxxl
}
