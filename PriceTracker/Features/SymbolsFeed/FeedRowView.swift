//
//  FeedRowView.swift
//  PriceTracker
//
//  Created by Ivan Shulev on 2.12.25.
//

import SwiftUI

struct FeedRowView: View {
    var rowViewModel: FeedRowViewModel
    
    var body: some View {
        HStack {
            Text(rowViewModel.ticker)
                .foregroundStyle(.textPrimary)
            Spacer()
            Text(rowViewModel.priceFormatted)
                .foregroundStyle(rowViewModel.isChanged ? (rowViewModel.isUp ? .green : .red) : .textPrimary)
            Image(systemName: rowViewModel.changeImageName)
                .foregroundStyle(rowViewModel.isUp ? .green : .red)
        }
        .background(.clear)
    }
}
