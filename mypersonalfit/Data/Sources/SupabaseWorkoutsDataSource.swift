//
//  SupabaseWorkoutsDataSource.swift
//  mypersonalfit
//

import Foundation

/// Reads workouts from Supabase's REST API (PostgREST) with plain URLSession, no SDK.
struct SupabaseWorkoutsDataSource {
    enum DataSourceError: Error, Equatable {
        case badStatus(Int)
    }

    /// Performs the HTTP call. Injected so tests can check the request without the network.
    typealias Transport = (URLRequest) async throws -> (Data, URLResponse)

    private let baseURL: URL
    private let apiKey: String
    private let transport: Transport

    init(
        baseURL: URL = BackendConfig.supabaseURL,
        apiKey: String = BackendConfig.supabasePublishableKey,
        transport: @escaping Transport = { try await URLSession.shared.data(for: $0) }
    ) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.transport = transport
    }

    /// `GET /rest/v1/workouts?select=*&order=sort_order.asc`
    func fetchWorkouts() async throws -> [Workout] {
        let (data, response) = try await transport(workoutsRequest())

        if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
            throw DataSourceError.badStatus(http.statusCode)
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode([Workout].self, from: data)
    }

    func workoutsRequest() -> URLRequest {
        var components = URLComponents(
            url: baseURL.appending(path: "rest/v1/workouts"),
            resolvingAgainstBaseURL: false
        )!
        components.queryItems = [
            URLQueryItem(name: "select", value: "*"),
            URLQueryItem(name: "order", value: "sort_order.asc")
        ]

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "apikey")
        // No signed-in user yet, so the publishable key is also the bearer token.
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
