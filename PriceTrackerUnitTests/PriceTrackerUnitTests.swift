//
//  PriceTrackerUnitTests.swift
//  PriceTrackerUnitTests
//
//  Created by Ivan Shulev on 3.12.25.
//

import XCTest
@testable import PriceTracker
import Combine

@MainActor
final class PriceTrackerUnitTests: XCTestCase {
    private var messagesInterpreter: MockMessagesInterpreter!
    private var webSocket: MockWebSocket!
    private var feedViewModel: SymbolsFeedViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        messagesInterpreter = MockMessagesInterpreter()
        webSocket = MockWebSocket(isConnectedValue: false)
        feedViewModel = SymbolsFeedViewModel(symbolsMessagesInterpreter: messagesInterpreter,
                                             webSocketClient: webSocket)
    }
        
    override func tearDown() {
        messagesInterpreter = nil
        webSocket = nil
        feedViewModel = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testSymbolsFeedViewModelConnectivity() throws {
        webSocket.connect()
        let expectation = expectation(description: "Connection status icon should correspond to connected.")
        
        feedViewModel.$connectionStatus
            .sink(receiveValue: { status in
                if status.iconName == "🟢" {
                    expectation.fulfill()
                }
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 2.0)
    }
    
    func testSymbolsFeedViewModel() throws {
        webSocket.connect()
        
        let items = (0..<25).map { index in
            PriceTracker.SymbolItem.init(ticker: "ticker_\(index)",
                                         name: "name_\(index)",
                                         price: 10.0,
                                         changePercent24H: 1.25)
        }
        
        let expectation = expectation(description: "Rows should be updated")
        
        feedViewModel.$rowViewModels
            .sink(receiveValue: { rows in
                let symbolItemsSet = Set(rows.map { $0.symbolItem })
                
                if rows.count == items.count {
                    for item in items {
                        if !symbolItemsSet.contains(item) {
                            return
                        }
                    }
                    
                    expectation.fulfill()
                }
            })
            .store(in: &cancellables)
        
        let snapshot = SymbolsSnapshot(items: items)
        messagesInterpreter.send(snapshot)
        
        waitForExpectations(timeout: 2.0)
    }
}
