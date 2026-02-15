//
//  SortOrderSheet.swift
//  TGLabNBA
//

import SwiftUI

struct SortOrderSheet: View {
    @Binding var selectedOrder: SortOrder
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List(SortOrder.allCases) { order in
                Button {
                    selectedOrder = order
                    dismiss()
                } label: {
                    HStack {
                        Text(order.displayTitle)
                            .foregroundStyle(.primary)
                        Spacer()
                        if order == selectedOrder {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.blue)
                        }
                    }
                }
                .accessibilityIdentifier("sort_option_\(order.rawValue)")
            }
            .navigationTitle("Sort By")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium])
    }
}
