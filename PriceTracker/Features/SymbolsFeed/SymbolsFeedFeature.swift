//
//  SymbolsFeedFeature.swift
//  PriceTracker
//
//  Created by Ivan Shulev on 2.12.25.
//

import SwiftUI

public struct SymbolsFeedFeature {
    func makeView(symbolsMessagesInterpreter: SymbolsMessagesInterpreter, webSocketClient: WebSocketClient) -> some View {
        SymbolsFeedView(viewModel: SymbolsFeedViewModel(symbolsMessagesInterpreter: symbolsMessagesInterpreter,
                                                        webSocketClient: webSocketClient))
    }
}
