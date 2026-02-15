//
//  GamesRepository.swift
//  TGLabNBA
//

import Foundation

protocol GamesRepository {
    func fetchGames(teamId: Int, cursor: Int?) async throws -> (games: [Game], nextCursor: Int?)
}
