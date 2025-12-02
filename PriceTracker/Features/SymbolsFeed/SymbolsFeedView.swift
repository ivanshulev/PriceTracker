//
//  SymbolsFeedView.swift
//  PriceTracker
//
//  Created by Ivan Shulev on 2.12.25.
//

import SwiftUI

struct SymbolsFeedView: View {
    @EnvironmentObject private var router: NavigationRouter
    @ObservedObject var viewModel: SymbolsFeedViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.rowViewModels, id: \.ticker) { rowViewModel in
                NavigationLink(value: AppRoute.details(ticker: rowViewModel.ticker)) {
                    HStack {
                        Text(rowViewModel.ticker)
                        Spacer()
                        Text(rowViewModel.priceFormatted)
                            .foregroundStyle(rowViewModel.isChanged ? (rowViewModel.isUp ? .green : .red) : .black)
                        Image(systemName: rowViewModel.changeImageName)
                            .foregroundStyle(rowViewModel.isUp ? .green : .red)
                    }
                    .contentShape(Rectangle())
                }
            }
        }
        .listStyle(.plain)
        .id(UUID())
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Text(viewModel.connectionStatus.iconName)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.toggleFeed()
                }) {
                    Text(viewModel.feedControlButtonTitle)
                }
            }
        })
        .padding()
        .onAppear {
            viewModel.connect()
        }
        .onDisappear {
            viewModel.disconnect()
        }
    }
}
