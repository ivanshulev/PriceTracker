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
    let symbolsMessagesInterpreter: SymbolsMessagesInterpreter
    let symbolsFeedFeature: SymbolsFeedFeature
    let symbolDetailsFeature: SymbolDetailsFeature
    
    let feedsSimulator: FeedsSimulator
    let stocksProvider: StocksProvider
    let symbolDetailsProvider: SymbolDetailsProvider
    
    init() {
        webSocketClient = WebSocketClient(webSocketURL: URL(string: "wss://ws.postman-echo.com/raw")!)
        symbolsMessagesInterpreter = SymbolsMessagesInterpreter(messageHandler: webSocketClient)
        stocksProvider = StocksProvider()
        
        feedsSimulator = FeedsSimulator(symbolsMessagesInterpreter: symbolsMessagesInterpreter,
                                        stocks: stocksProvider.loadStocks())
        symbolDetailsProvider = SymbolDetailsProvider(stocks: stocksProvider.loadStocks())
        
        symbolsFeedFeature = SymbolsFeedFeature()
        symbolDetailsFeature = SymbolDetailsFeature(symbolsMessagesInterpreter: symbolsMessagesInterpreter,
                                                    symbolDetailsProvider: symbolDetailsProvider)
    }
    
    func rootView() -> some View {
        symbolsFeedFeature.makeView(symbolsMessagesInterpreter: symbolsMessagesInterpreter, webSocketClient: webSocketClient)
    }
}
