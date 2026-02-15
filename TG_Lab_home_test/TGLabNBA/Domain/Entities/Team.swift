//
//  Team.swift
//  TGLabNBA
//

import Foundation

struct Team: Identifiable, Equatable, Hashable {
    let id: Int
    let fullName: String
    let name: String
    let city: String
    let conference: String
    let abbreviation: String

    var logoURL: URL? {
        URL(string: "https://a.espncdn.com/i/teamlogos/nba/500/\(abbreviation.lowercased()).png")
    }
}
