//
//  LocalJSONDataSource.swift
//  TGLabNBA
//

import Foundation

struct LocalJSONDataSource: HTTPClient {

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        // Simulate network latency
        try await Task.sleep(for: .milliseconds(300))

        guard let url = request.url else {
            throw NetworkError.invalidURL
        }

        let fileName = resolveFileName(for: url)

        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw NetworkError.resourceNotFound(fileName)
        }

        let data = try Data(contentsOf: fileURL)
        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: "HTTP/1.1",
            headerFields: ["Content-Type": "application/json"]
        )!

        return (data, response)
    }

    private func resolveFileName(for url: URL) -> String {
        let path = url.path()

        if path.contains("/teams") {
            return "teams"
        } else if path.contains("/games") {
            return "games"
        } else if path.contains("/players") {
            return "players"
        }

        return "unknown"
    }
}
