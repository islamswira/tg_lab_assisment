//
//  HTTPClient.swift
//  TGLabNBA
//

import Foundation

protocol HTTPClient {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: HTTPClient {}

struct LoggingHTTPClient: HTTPClient {
    private let base: HTTPClient
    private let logger: AppLogging

    init(base: HTTPClient, logger: AppLogging) {
        self.base = base
        self.logger = logger
    }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        let method = request.httpMethod ?? "GET"
        let url = request.url?.absoluteString ?? "<nil>"

        logger.debug("\(method) \(url)")

        do {
            let (data, response) = try await base.data(for: request)

            if let http = response as? HTTPURLResponse {
                logger.info("\(method) \(url) → \(http.statusCode) (\(data.count) bytes)")
            }

            return (data, response)
        } catch {
            logger.error("\(method) \(url) failed: \(error)")
            throw error
        }
    }
}
