//
//  ProgramsRepository.swift
//  mypersonalfit
//

import Foundation

protocol ProgramsRepository {
    func fetchHome() async throws -> ProgramsHome
}

struct MockProgramsRepository: ProgramsRepository {
    private let dataSource = MockProgramsDataSource()

    func fetchHome() async throws -> ProgramsHome {
        try await dataSource.fetchHome()
    }
}

/// Proof of concept (MYP-6): builds the Programs home from the Supabase `workouts` table.
/// Until the real API exists (MYP-9), the first workout is featured and the rest are popular.
struct SupabaseProgramsRepository: ProgramsRepository {
    enum RepositoryError: Error, Equatable {
        case noWorkouts
    }

    var dataSource = SupabaseWorkoutsDataSource()

    func fetchHome() async throws -> ProgramsHome {
        let workouts = try await dataSource.fetchWorkouts()
        guard let featured = workouts.first else { throw RepositoryError.noWorkouts }

        return ProgramsHome(
            // No signed-in user yet; replaced by the user's display name with auth.
            userName: "Athlete",
            featured: FeaturedWorkout(workout: featured, badge: "TODAY'S PICK"),
            categories: WorkoutCategory.allCases,
            popularWorkouts: Array(workouts.dropFirst())
        )
    }
}
