//
//  TeamsRepository.swift
//  TGLabNBA
//

import Foundation

protocol TeamsRepository {
    func fetchTeams() async throws -> [Team]
}
