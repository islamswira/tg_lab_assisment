//
//  Player.swift
//  TGLabNBA
//

import Foundation

struct Player: Identifiable, Equatable {
    let id: Int
    let firstName: String
    let lastName: String
    let position: String
    let team: Team
}
