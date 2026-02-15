//
//  APIEndpoints.swift
//  TGLabNBA
//

import Foundation

enum APIEndpoints {
    static let baseURL = "https://api.balldontlie.io/v1"

    static var teams: URL {
        URL(string: "\(baseURL)/teams")!
    }

    static func games(teamId: Int, cursor: Int? = nil, perPage: Int = 25) -> URL {
        var components = URLComponents(string: "\(baseURL)/games")!
        var queryItems = [
            URLQueryItem(name: "team_ids[]", value: "\(teamId)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        if let cursor {
            queryItems.append(URLQueryItem(name: "cursor", value: "\(cursor)"))
        }
        components.queryItems = queryItems
        return components.url!
    }

    static func players(search: String, cursor: Int? = nil, perPage: Int = 25) -> URL {
        var components = URLComponents(string: "\(baseURL)/players")!
        var queryItems = [
            URLQueryItem(name: "search", value: search),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        if let cursor {
            queryItems.append(URLQueryItem(name: "cursor", value: "\(cursor)"))
        }
        components.queryItems = queryItems
        return components.url!
    }
}
