//
//  PaginatedResponseDTO.swift
//  TGLabNBA
//

import Foundation

struct PaginatedResponseDTO<T: Decodable>: Decodable {
    let data: [T]
    let meta: Meta?

    struct Meta: Decodable {
        let nextCursor: Int?
        let perPage: Int?
    }
}
