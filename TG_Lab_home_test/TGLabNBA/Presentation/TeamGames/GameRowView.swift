//
//  GameRowView.swift
//  TGLabNBA
//

import SwiftUI

struct GameRowView: View {
    let game: Game

    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text(game.homeTeam.fullName)
                    .font(.subheadline)
                Text(game.visitorTeam.fullName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 2) {
                Text("\(game.homeScore)")
                    .font(.subheadline).bold()
                Text("\(game.visitorScore)")
                    .font(.subheadline).bold()
                    .foregroundStyle(.secondary)
            }
            .frame(width: 40)

            Text(formattedDate)
                .font(.caption2)
                .foregroundStyle(.tertiary)
                .frame(width: 70)
        }
        .padding(.vertical, 4)
    }

    private var formattedDate: String {
        // date comes as "2024-10-22" — show as "Oct 22"
        let parts = game.date.split(separator: "T").first.map(String.init) ?? game.date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: parts) else { return game.date }
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}
