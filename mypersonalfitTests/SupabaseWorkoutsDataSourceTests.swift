//
//  SupabaseWorkoutsDataSourceTests.swift
//  mypersonalfitTests
//

import XCTest
@testable import mypersonalfit

final class SupabaseWorkoutsDataSourceTests: XCTestCase {
    private let baseURL = URL(string: "https://example.supabase.co")!
    private let apiKey = "test-publishable-key"

    private let workoutsJSON = Data("""
    [
      {"id": "full-body-30", "title": "Full Body", "duration_minutes": 30, "level": "intermediate",
       "category": "strength", "estimated_calories": 320, "trainer_name": "Alex Rivera",
       "image_name": "WorkoutFullBody", "sort_order": 0},
      {"id": "core-25", "title": "Core", "duration_minutes": 25, "level": "beginner",
       "category": "core", "estimated_calories": 180, "trainer_name": "Jordan Lee",
       "image_name": "WorkoutCore", "sort_order": 1}
    ]
    """.utf8)

    private func dataSource(
        status: Int = 200,
        body: Data,
        onRequest: @escaping (URLRequest) -> Void = { _ in }
    ) -> SupabaseWorkoutsDataSource {
        SupabaseWorkoutsDataSource(baseURL: baseURL, apiKey: apiKey) { request in
            onRequest(request)
            let response = HTTPURLResponse(url: request.url!, statusCode: status, httpVersion: nil, headerFields: nil)!
            return (body, response)
        }
    }

    func testRequestTargetsWorkoutsTableWithAuthHeaders() throws {
        let request = dataSource(body: Data()).workoutsRequest()
        let components = try XCTUnwrap(URLComponents(url: try XCTUnwrap(request.url), resolvingAgainstBaseURL: false))

        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(components.host, "example.supabase.co")
        XCTAssertEqual(components.path, "/rest/v1/workouts")
        XCTAssertEqual(components.queryItems?.first { $0.name == "order" }?.value, "sort_order.asc")
        XCTAssertEqual(request.value(forHTTPHeaderField: "apikey"), apiKey)
        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer \(apiKey)")
    }

    func testDecodesSnakeCaseRowsIntoWorkouts() async throws {
        let workouts = try await dataSource(body: workoutsJSON).fetchWorkouts()

        XCTAssertEqual(workouts.map(\.id), ["full-body-30", "core-25"])
        XCTAssertEqual(workouts[0].durationMinutes, 30)
        XCTAssertEqual(workouts[0].level, .intermediate)
        XCTAssertEqual(workouts[0].estimatedCalories, 320)
        XCTAssertEqual(workouts[0].trainerName, "Alex Rivera")
        XCTAssertEqual(workouts[1].category, .core)
        XCTAssertEqual(workouts[1].imageName, "WorkoutCore")
    }

    func testNonSuccessStatusThrows() async {
        let body = Data(#"{"message": "Invalid API key"}"#.utf8)
        do {
            _ = try await dataSource(status: 401, body: body).fetchWorkouts()
            XCTFail("Expected an error")
        } catch {
            XCTAssertEqual(error as? SupabaseWorkoutsDataSource.DataSourceError, .badStatus(401))
        }
    }

    func testRepositoryFeaturesFirstWorkoutAndListsTheRestAsPopular() async throws {
        let repository = SupabaseProgramsRepository(dataSource: dataSource(body: workoutsJSON))

        let home = try await repository.fetchHome()

        XCTAssertEqual(home.featured.workout.id, "full-body-30")
        XCTAssertEqual(home.popularWorkouts.map(\.id), ["core-25"])
    }

    func testRepositoryThrowsWhenTableIsEmpty() async {
        let repository = SupabaseProgramsRepository(dataSource: dataSource(body: Data("[]".utf8)))
        do {
            _ = try await repository.fetchHome()
            XCTFail("Expected an error")
        } catch {
            XCTAssertEqual(error as? SupabaseProgramsRepository.RepositoryError, .noWorkouts)
        }
    }
}
