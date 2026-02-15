//
//  GameDTO.swift
//  TGLabNBA
//

import Foundation

struct GameDTO: Decodable {
    let id: Int
    let date: String
    let homeTeamScore: Int
    let visitorTeamScore: Int
    let homeTeam: TeamDTO
    let visitorTeam: TeamDTO

    func toDomain() -> Game {
        Game(
            id: id,
            date: date,
            homeTeam: homeTeam.toDomain(),
            homeScore: homeTeamScore,
            visitorTeam: visitorTeam.toDomain(),
            visitorScore: visitorTeamScore
        )
    }
}
