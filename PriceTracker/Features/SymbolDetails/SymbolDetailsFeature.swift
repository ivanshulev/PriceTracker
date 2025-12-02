//
//  SymbolDetailsFeature.swift
//  learn_websocket
//
//  Created by Ivan Shulev on 2.12.25.
//

import SwiftUI

public struct SymbolDetailsFeature {
    private let symbolsMessagesInterpreter: SymbolsMessagesInterpreter
    private let symbolDetailsProvider: SymbolDetailsProvider
    
    init(symbolsMessagesInterpreter: SymbolsMessagesInterpreter,
         symbolDetailsProvider: SymbolDetailsProvider) {
        self.symbolsMessagesInterpreter = symbolsMessagesInterpreter
        self.symbolDetailsProvider = symbolDetailsProvider
    }
    
    func makeView(ticker: String) -> some View {
        let viewModel = SymbolDetailsViewModel(ticker: ticker,
                                               symbolsMessagesInterpreter: symbolsMessagesInterpreter,
                                               symbolDetailsProvider: symbolDetailsProvider)
        return SymbolDetailsView(viewModel: viewModel)
    }
}
