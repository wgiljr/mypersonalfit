//
//  ProgramsHome.swift
//  mypersonalfit
//

import Foundation

struct FeaturedWorkout: Codable, Hashable {
    let workout: Workout
    /// Short label shown over the hero card, e.g. "TODAY'S PICK".
    let badge: String
}

/// Everything the Programs (home) screen needs, in a single response.
struct ProgramsHome: Codable, Hashable {
    let userName: String
    let featured: FeaturedWorkout
    let categories: [WorkoutCategory]
    let popularWorkouts: [Workout]
}
