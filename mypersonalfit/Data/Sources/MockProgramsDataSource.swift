//
//  MockProgramsDataSource.swift
//  mypersonalfit
//

import Foundation

/// Stands in for the backend until it exists. Mirrors the shape of the real response.
struct MockProgramsDataSource {
    func fetchHome() async throws -> ProgramsHome {
        ProgramsHome(
            userName: "Maria",
            featured: FeaturedWorkout(
                workout: Workout(
                    id: "full-body-30",
                    title: "Full Body",
                    durationMinutes: 30,
                    level: .intermediate,
                    category: .strength,
                    estimatedCalories: 320,
                    trainerName: "Alex Rivera",
                    imageName: "WorkoutFullBody"
                ),
                badge: "TODAY'S PICK"
            ),
            categories: WorkoutCategory.allCases,
            popularWorkouts: [
                Workout(
                    id: "lower-body-25",
                    title: "Lower Body",
                    durationMinutes: 25,
                    level: .beginner,
                    category: .strength,
                    estimatedCalories: 240,
                    trainerName: "Sam Carter",
                    imageName: "WorkoutLowerBody"
                ),
                Workout(
                    id: "core-25",
                    title: "Core",
                    durationMinutes: 25,
                    level: .beginner,
                    category: .core,
                    estimatedCalories: 180,
                    trainerName: "Jordan Lee",
                    imageName: "WorkoutCore"
                )
            ]
        )
    }
}
