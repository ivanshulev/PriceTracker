//
//  SymbolDetailsFeature.swift
//  learn_websocket
//
//  Created by Ivan Shulev on 2.12.25.
//

import SwiftUI

public struct SymbolDetailsFeature {
    private let messagesInterpreter: MessagesInterpreter
    private let symbolDetailsProvider: SymbolDetailsProvider
    
    init(messagesInterpreter: MessagesInterpreter,
         symbolDetailsProvider: SymbolDetailsProvider) {
        self.messagesInterpreter = messagesInterpreter
        self.symbolDetailsProvider = symbolDetailsProvider
    }
    
    func makeView(ticker: String) -> some View {
        let viewModel = SymbolDetailsViewModel(ticker: ticker,
                                               messagesInterpreter: messagesInterpreter,
                                               symbolDetailsProvider: symbolDetailsProvider)
        return SymbolDetailsView(viewModel: viewModel)
    }
}
