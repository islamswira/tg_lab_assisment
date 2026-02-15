//
//  SortOrder.swift
//  TGLabNBA
//

import Foundation

enum SortOrder: String, CaseIterable, Identifiable {
    case name = "Name"
    case city = "City"
    case conference = "Conference"

    var id: String { rawValue }

    var displayTitle: String { rawValue }
}
