//
//  Game.swift
//  TGLabNBA
//

import Foundation

struct Game: Identifiable, Equatable {
    let id: Int
    let date: String
    let homeTeam: Team
    let homeScore: Int
    let visitorTeam: Team
    let visitorScore: Int
}
