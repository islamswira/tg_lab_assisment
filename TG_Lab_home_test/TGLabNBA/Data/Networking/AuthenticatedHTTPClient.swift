//
//  AuthenticatedHTTPClient.swift
//  TGLabNBA
//

import Foundation

struct AuthenticatedHTTPClient: HTTPClient {
    private let base: HTTPClient
    private let apiKey: String

    init(base: HTTPClient, apiKey: String) {
        self.base = base
        self.apiKey = apiKey
    }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        var req = request
        req.setValue(apiKey, forHTTPHeaderField: "Authorization")
        return try await base.data(for: req)
    }
}
