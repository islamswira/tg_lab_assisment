//
//  PlayerDTO.swift
//  TGLabNBA
//

import Foundation

struct PlayerDTO: Decodable {
    let id: Int
    let firstName: String
    let lastName: String
    let position: String
    let team: TeamDTO

    func toDomain() -> Player {
        Player(
            id: id,
            firstName: firstName,
            lastName: lastName,
            position: position,
            team: team.toDomain()
        )
    }
}
