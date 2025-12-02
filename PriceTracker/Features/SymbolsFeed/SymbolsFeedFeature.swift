//
//  SymbolsFeedFeature.swift
//  learn_websocket
//
//  Created by Ivan Shulev on 1.12.25.
//

import SwiftUI

public struct SymbolsFeedFeature {
    func makeView(symbolsMessagesInterpreter: SymbolsMessagesInterpreter, webSocketClient: WebSocketClient) -> some View {
        SymbolsFeedView(viewModel: SymbolsFeedViewModel(symbolsMessagesInterpreter: symbolsMessagesInterpreter,
                                                        webSocketClient: webSocketClient))
    }
}
