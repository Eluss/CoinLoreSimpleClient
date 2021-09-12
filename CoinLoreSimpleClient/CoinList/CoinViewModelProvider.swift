//
//  CoinViewModelProvider.swift
//  CoinLoreSimpleClient
//
//  Created by Eliasz Sawicki on 11/09/2021.
//

import Foundation

protocol CoinViewModelsProvider {
    func coinsViewModels(currentCoins: [Coin], lastCoins: [Coin], sortingCriteria: SortingCriteria) -> [CoinCellViewModel]
}

class DefaultCoinViewModelsProvider: CoinViewModelsProvider {
    
    private let coinSorter: CoinSorter
    
    init(coinSorter: CoinSorter = CoinSorter()) {
        self.coinSorter = coinSorter
    }
    
    func coinsViewModels(currentCoins: [Coin], lastCoins: [Coin], sortingCriteria: SortingCriteria) -> [CoinCellViewModel] {
        let sortedCoins = coinSorter.sort(coins: currentCoins, criteria: sortingCriteria)
        var lastPrices: [String: String] = [:]
        lastCoins.forEach { coin in
            lastPrices[coin.id] = coin.priceUSD
        }        
        return sortedCoins.map { coin in
            let trend = growthTrendFor(lastPrice: lastPrices[coin.id], currentPrice: coin.priceUSD)
            return CoinCellViewModel(coin: coin, growthTrend: trend)
        }
    }
    
    private func growthTrendFor(lastPrice: String?, currentPrice: String) -> GrowthTrend {
        guard let startPrice = Double(lastPrice ?? ""),
              let endPrice = Double(currentPrice) else { return .noChange }
        if startPrice > endPrice {
            return .fall
        } else if startPrice < endPrice {
            return .rise
        }
        return .noChange
    }
}
