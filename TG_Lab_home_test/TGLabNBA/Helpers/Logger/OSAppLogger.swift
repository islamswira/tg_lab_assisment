//
//  OSAppLogger.swift
//  TGLabNBA
//

import Foundation
import os

struct OSAppLogger: AppLogging {
    private let logger: os.Logger

    init(category: String) {
        self.logger = os.Logger(
            subsystem: Bundle.main.bundleIdentifier ?? "com.islamswira.TGLabNBA",
            category: category
        )
    }

    func debug(_ message: String)   { logger.debug("🔍 \(message, privacy: .public)") }
    func info(_ message: String)    { logger.info("ℹ️ \(message, privacy: .public)") }
    func warning(_ message: String) { logger.warning("⚠️ \(message, privacy: .public)") }
    func error(_ message: String)   { logger.error("❌ \(message, privacy: .public)") }
}
