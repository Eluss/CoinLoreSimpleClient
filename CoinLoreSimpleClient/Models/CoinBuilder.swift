//
//  CoinBuilder.swift
//  CoinBuilder
//
//  Created by Eliasz Sawicki on 11/09/2021.
//

import Foundation

class CoinBuilder {
    
    private var name: String = "Bitcoin"
    private var id: String = "1"
    private var priceUSD: String = "45310.36"
    private var percentChange24: String = "-2.17"
    private var percentChange1: String = "0.59"
    private var volume24: Double = 30804184045.37688
    private var symbol: String = "BTC"
    
    func with(id: String) -> Self {
        self.id = id
        return self
    }
    
    func with(symbol: String) -> Self {
        self.symbol = symbol
        return self
    }
    
    func with(priceUSD: String) -> Self {
        self.priceUSD = priceUSD
        return self
    }
    
    func with(name: String) -> Self {
        self.name = name
        return self
    }
    
    func withPercentChange24(percentChange24: String) -> Self {
        self.percentChange24 = percentChange24
        return self
    }
    
    func withPercentChange1(percentChange1: String) -> Self {
        self.percentChange1 = percentChange1
        return self
    }
    
    func withVolume24(volume24: Double) -> Self {
        self.volume24 = volume24
        return self
    }
    
    func build() -> Coin {
        let coin = Coin(id: id,
             symbol: symbol,
             name: name,
             priceUSD: priceUSD,
             percentChange24h: percentChange24,
             percentChange1h: percentChange1,
             volume24:  volume24)
        return coin
    }
    
}
