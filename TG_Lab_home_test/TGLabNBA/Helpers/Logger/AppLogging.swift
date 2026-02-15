//
//  AppLogging.swift
//  TGLabNBA
//

import Foundation

protocol AppLogging {
    func debug(_ message: String)
    func info(_ message: String)
    func warning(_ message: String)
    func error(_ message: String)
}
