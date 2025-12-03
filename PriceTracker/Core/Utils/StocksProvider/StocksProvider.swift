//
//  StocksProvider.swift
//  learn_websocket
//
//  Created by Ivan Shulev on 2.12.25.
//

import Foundation

class StocksProvider {
    private var stocks: [Stock]?
    
    enum JSONLoadingError: Error {
        case fileNotFound
        case invalidData
    }
    
    func loadStocksAsync() async -> [Stock] {
        return await Task.detached { [weak self] in
            await self?.loadStocks() ?? []
        }.value
    }
    
    func loadStocks() -> [Stock] {
        guard let stocks = self.stocks else {
            self.stocks = try? loadStocksFromBundle()
            return stocks ?? []
        }
        
        return stocks
    }
    
    private func loadStocksFromBundle() throws -> [Stock] {
        guard let url = Bundle.main.url(forResource: "SymbolsFeedSeed", withExtension: "json") else {
            throw JSONLoadingError.fileNotFound
        }
        
        let data: Data
        
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw JSONLoadingError.invalidData
        }
        
        let decoder = JSONDecoder()
        
        do {
            let stocks = try decoder.decode([Stock].self, from: data)
            return stocks
        } catch {
            print("Decoding failed: \(error)")
            throw error
        }
    }
}
