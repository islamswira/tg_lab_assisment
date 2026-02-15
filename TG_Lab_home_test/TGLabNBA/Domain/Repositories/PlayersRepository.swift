//
//  PlayersRepository.swift
//  TGLabNBA
//

import Foundation

protocol PlayersRepository {
    func searchPlayers(query: String, cursor: Int?) async throws -> (players: [Player], nextCursor: Int?)
}
