//
//  Coin.swift
//  CoinLoreSimpleClient
//
//  Created by Eliasz Sawicki on 10/09/2021.
//

import Foundation

struct CoinsResponse: Codable {    
    private enum CodingKeys: String, CodingKey {
        case coins = "data"
    }
    
    let coins: [Coin]
}

struct Coin: Codable, Identifiable, Equatable {
    
    private enum CodingKeys: String, CodingKey {
        case id, symbol, name, volume24
        case priceUSD = "price_usd"
        case percentChange24h = "percent_change_24h"
        case percentChange1h = "percent_change_1h"
    }
    
    let id: String
    let symbol: String
    let name: String
    let priceUSD: String
    let percentChange24h: String
    let percentChange1h: String
    let volume24: Double    
}
