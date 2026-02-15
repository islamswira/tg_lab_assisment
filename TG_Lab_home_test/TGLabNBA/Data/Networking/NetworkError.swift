//
//  NetworkError.swift
//  TGLabNBA
//

import Foundation

enum NetworkError: Error, Equatable {
    case invalidResponse
    case httpStatus(Int)
    case decoding
    case invalidURL
    case resourceNotFound(String)
}
