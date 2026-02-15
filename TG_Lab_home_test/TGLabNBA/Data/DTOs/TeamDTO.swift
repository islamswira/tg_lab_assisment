//
//  TeamDTO.swift
//  TGLabNBA
//

import Foundation

struct TeamDTO: Decodable {
    let id: Int
    let conference: String
    let division: String
    let city: String
    let name: String
    let fullName: String
    let abbreviation: String

    func toDomain() -> Team {
        Team(
            id: id,
            fullName: fullName,
            name: name,
            city: city,
            conference: conference,
            abbreviation: abbreviation
        )
    }
}
