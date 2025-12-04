//
//  SymbolsFeedFeature.swift
//  learn_websocket
//
//  Created by Ivan Shulev on 1.12.25.
//

import SwiftUI

public struct SymbolsFeedFeature {
    func makeView(messagesInterpreter: MessagesInterpreter, webSocketClient: WebSocketClient) -> some View {
        SymbolsFeedView(viewModel: SymbolsFeedViewModel(messagesInterpreter: messagesInterpreter,
                                                        webSocketClient: webSocketClient))
    }
}
