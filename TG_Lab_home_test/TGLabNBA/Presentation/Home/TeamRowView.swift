//
//  TeamRowView.swift
//  TGLabNBA
//

import SwiftUI
import Kingfisher

struct TeamRowView: View {
    let team: Team

    var body: some View {
        HStack(spacing: 12) {
            KFImage(team.logoURL)
                .resizable()
                .placeholder {
                    Image(systemName: "sportscourt")
                        .foregroundStyle(.secondary)
                }
                .scaledToFit()
                .frame(width: 36, height: 36)

            Text(team.fullName)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(team.city)
                .font(.body)
                .foregroundStyle(.secondary)
                .frame(width: 90, alignment: .leading)

            Text(team.conference)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(team.conference == "East" ? Color.blue.opacity(0.15) : Color.red.opacity(0.15))
                .clipShape(Capsule())
                .frame(width: 60)
        }
        .accessibilityIdentifier("team_row_\(team.id)")
    }
}
