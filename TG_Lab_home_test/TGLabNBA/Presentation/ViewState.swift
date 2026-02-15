//
//  ViewState.swift
//  TGLabNBA
//

import Foundation

enum ViewState: Equatable {
    case idle, loading, loaded, error(String)
}
