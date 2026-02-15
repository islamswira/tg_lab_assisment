//
//  PlayerRowView.swift
//  TGLabNBA
//

import SwiftUI
import Kingfisher

struct PlayerRowView: View {
    let player: Player

    var body: some View {
        HStack(spacing: 12) {
            KFImage(player.team.logoURL)
                .resizable()
                .placeholder {
                    Image(systemName: "person.circle")
                        .foregroundStyle(.secondary)
                }
                .scaledToFit()
                .frame(width: 32, height: 32)

            Text(player.firstName)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(player.lastName)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(player.team.fullName)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 100, alignment: .trailing)
                .lineLimit(2)
        }
    }
}
