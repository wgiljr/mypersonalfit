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
