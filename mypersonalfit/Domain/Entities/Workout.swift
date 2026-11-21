//
//  Workout.swift
//  mypersonalfit
//

import Foundation

enum WorkoutLevel: String, Codable, Hashable {
    case beginner
    case intermediate
    case advanced

    var displayName: String {
        switch self {
        case .beginner: "Beginner"
        case .intermediate: "Intermediate"
        case .advanced: "Advanced"
        }
    }
}

enum WorkoutCategory: String, Codable, CaseIterable, Identifiable, Hashable {
    case strength
    case cardio
    case core
    case mobility

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .strength: "Strength"
        case .cardio: "Cardio"
        case .core: "Core"
        case .mobility: "Mobility"
        }
    }
}

struct Workout: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let durationMinutes: Int
    let level: WorkoutLevel
    let category: WorkoutCategory
    let estimatedCalories: Int
    let trainerName: String
    /// Name of a local image today; becomes a remote URL once the backend exists.
    let imageName: String

    /// e.g. "30 min • Intermediate"
    var summary: String {
        "\(durationMinutes) min • \(level.displayName)"
    }
}
