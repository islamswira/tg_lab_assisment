//
//  TeamsRepositoryImpl.swift
//  TGLabNBA
//

import Foundation

final class TeamsRepositoryImpl: TeamsRepository {
    private let client: HTTPClient
    private let logger: AppLogging

    init(client: HTTPClient, logger: AppLogging) {
        self.client = client
        self.logger = logger
    }

    func fetchTeams() async throws -> [Team] {
        let request = URLRequest(url: APIEndpoints.teams)
        let (data, response) = try await client.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(http.statusCode) else {
            logger.error("Teams request returned \(http.statusCode)")
            throw NetworkError.httpStatus(http.statusCode)
        }

        do {
            let dto = try JSONDecoder.api.decode(PaginatedResponseDTO<TeamDTO>.self, from: data)
            return dto.data.map { $0.toDomain() }
        } catch {
            logger.error("Teams decoding failed: \(error)")
            throw NetworkError.decoding
        }
    }
}
