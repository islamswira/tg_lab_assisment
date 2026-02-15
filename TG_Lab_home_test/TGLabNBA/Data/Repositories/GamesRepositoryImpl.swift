//
//  GamesRepositoryImpl.swift
//  TGLabNBA
//

import Foundation

final class GamesRepositoryImpl: GamesRepository {
    private let client: HTTPClient
    private let logger: AppLogging

    init(client: HTTPClient, logger: AppLogging) {
        self.client = client
        self.logger = logger
    }

    func fetchGames(teamId: Int, cursor: Int?) async throws -> (games: [Game], nextCursor: Int?) {
        let url = APIEndpoints.games(teamId: teamId, cursor: cursor)
        let request = URLRequest(url: url)
        let (data, response) = try await client.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(http.statusCode) else {
            logger.error("Games request returned \(http.statusCode)")
            throw NetworkError.httpStatus(http.statusCode)
        }

        do {
            let dto = try JSONDecoder.api.decode(PaginatedResponseDTO<GameDTO>.self, from: data)
            return (dto.data.map { $0.toDomain() }, dto.meta?.nextCursor)
        } catch {
            logger.error("Games decoding failed: \(error)")
            throw NetworkError.decoding
        }
    }
}
