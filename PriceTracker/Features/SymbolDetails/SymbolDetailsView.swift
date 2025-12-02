//
//  SymbolDetailsView.swift
//  learn_websocket
//
//  Created by Ivan Shulev on 2.12.25.
//

import SwiftUI

struct SymbolDetailsView: View {
    @StateObject var viewModel: SymbolDetailsViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text(viewModel.details.ticker)
                        Text(viewModel.details.name)
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                    
                    Spacer()
                    
                    HStack {
                        Text(viewModel.priceFormatted)
                        Image(systemName: viewModel.changeImageName)
                            .foregroundStyle(viewModel.isUp ? .green : .red)
                    }
                }
                
                Text(viewModel.details.description)
            }
        }
        .padding()
        .onAppear {
            viewModel.fetchDetails()
            viewModel.startObservingFeed()
        }
        .onDisappear {
            viewModel.stopObservingFeed()
        }
    }
}
