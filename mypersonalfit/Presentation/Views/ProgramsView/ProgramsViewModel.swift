//
//  ProgramsViewModel.swift
//  mypersonalfit
//

import Foundation
import Observation

@MainActor
@Observable
final class ProgramsViewModel {
    enum State {
        case loading
        case loaded(ProgramsHome)
        case failed
    }

    private(set) var state: State = .loading

    private let repository: ProgramsRepository

    init(repository: ProgramsRepository = MockProgramsRepository()) {
        self.repository = repository
    }

    func load() async {
        do {
            state = .loaded(try await repository.fetchHome())
        } catch {
            state = .failed
        }
    }

    static func greeting(for date: Date = .now, calendar: Calendar = .current) -> String {
        switch calendar.component(.hour, from: date) {
        case 5..<12: "Good morning,"
        case 12..<18: "Good afternoon,"
        default: "Good evening,"
        }
    }
}
