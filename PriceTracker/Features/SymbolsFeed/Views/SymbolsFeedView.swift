//
//  SymbolsFeedView.swift
//  learn_websocket
//
//  Created by Ivan Shulev on 1.12.25.
//

import SwiftUI

struct SymbolsFeedView: View {
    @EnvironmentObject private var router: NavigationRouter
    @StateObject var viewModel: SymbolsFeedViewModel
    
    var body: some View {
        Group {
            switch viewModel.viewState {
            case .inProgress:
                ProgressView(viewModel.progressStateMessage)
            case .failure(let message):
                Text(message)
            case .successful:
                List {
                    ForEach(viewModel.rowViewModels, id: \.ticker) { rowViewModel in
                        NavigationLink(value: AppRoute.details(ticker: rowViewModel.ticker)) {
                            FeedRowView(rowViewModel: rowViewModel)
                        }
                        .accessibilityIdentifier("feed_itemRow_\(rowViewModel.index)")
                    }
                }
                .accessibilityIdentifier("feed_list")
                .listStyle(.plain)
                .background(Color.clear)
                .listRowBackground(Color.clear)
                .scrollContentBackground(.hidden)
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Text(viewModel.connectionStatus.iconName)
                    .accessibilityIdentifier("feed_connectionStatusTitle")
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.toggleFeed()
                }) {
                    Text(viewModel.feedControlButtonTitle)
                        .accessibilityIdentifier("feed_toggleButtonTitle")
                }
                .accessibilityIdentifier("feed_toggleButton")
            }
        })
        .padding()
        .onAppear {
            viewModel.startObservingFeed()
        }
        .onDisappear {
            viewModel.stopObservingFeed()
        }
    }
}
