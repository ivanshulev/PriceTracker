//
//  AppContainer.swift
//  PriceTracker
//
//  Created by Ivan Shulev on 2.12.25.
//

import SwiftUI
import Combine

@MainActor
class AppContainer: ObservableObject {
    let webSocketClient: WebSocketClient
//    let symbolsMessagesInterpreter: SymbolsMessagesInterpreter
    let customMessagesInterpreter: CustomMessagesInterpreter
    let symbolsFeedFeature: SymbolsFeedFeature
    let symbolDetailsFeature: SymbolDetailsFeature
    
    let feedsSimulator: FeedsSimulator
    let stocksProvider: StocksProvider
    let symbolDetailsProvider: SymbolDetailsProvider
    
    init() {
        webSocketClient = WebSocketClient(webSocketURL: URL(string: "wss://ws.postman-echo.com/raw")!)
//        symbolsMessagesInterpreter = SymbolsMessagesInterpreter(messageHandler: webSocketClient)
        customMessagesInterpreter = CustomMessagesInterpreter(messageHandler: webSocketClient)
        stocksProvider = StocksProvider()
        
        feedsSimulator = FeedsSimulator(messagesInterpreter: customMessagesInterpreter,
                                        stocksProvider: stocksProvider)
        symbolDetailsProvider = SymbolDetailsProvider(stocks: stocksProvider.loadStocks())
        
        symbolsFeedFeature = SymbolsFeedFeature()
        symbolDetailsFeature = SymbolDetailsFeature(messagesInterpreter: customMessagesInterpreter,
                                                    symbolDetailsProvider: symbolDetailsProvider)
    }
    
    func rootView() -> some View {
        symbolsFeedFeature.makeView(messagesInterpreter: customMessagesInterpreter, webSocketClient: webSocketClient)
    }
}
