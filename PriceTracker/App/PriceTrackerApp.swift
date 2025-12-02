//
//  PriceTrackerApp.swift
//  PriceTracker
//
//  Created by Ivan Shulev on 2.12.25.
//

import SwiftUI

@main
struct PriceTrackerApp: App {
    @StateObject private var container = AppContainer()
    @StateObject private var router = NavigationRouter()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                container.rootView()
                    .environmentObject(router)
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .feed:
                            container.rootView()
                        case .details(let ticker):
                            container.symbolDetailsFeature.makeView(ticker: ticker)
                        }
                    }
            }
            .onAppear {
                container.webSocketClient.connect()
                container.feedsSimulator.start()
            }
            .onOpenURL { url in
                handleDeepLink(url)
            }
        }
    }
    
    private func handleDeepLink(_ url: URL) {
        guard url.scheme?.lowercased() == "stockstrack" else {
            return
        }
        
        router.openDetailsFor(ticker: url.host ?? "")
    }
}
