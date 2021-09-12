//
//  CoinSorter.swift
//  CoinSorter
//
//  Created by Eliasz Sawicki on 11/09/2021.
//

import Foundation

enum SortingCriteria: String, Identifiable, CaseIterable, Equatable {
    
    case name
    case volume
    case percentChange
    
    var id: String { self.rawValue }
    
    func displayText() -> String {
        switch self {
        case .name: return "Name"
        case .volume: return "Volume"
        case .percentChange: return "24h"
        }
    }
}

class CoinSorter {
    
    func sort(coins: [Coin], criteria: SortingCriteria) -> [Coin] {
        switch criteria {
        case .name: return sortByName(coins)
        case .percentChange: return sortByPercentageChange(coins)
        case .volume: return sortByVolume(coins)
        }
    }
    
    private func sortByName(_ coins: [Coin]) -> [Coin] {
        coins.sorted { $0.name < $1.name }
    }
    
    private func sortByPercentageChange(_ coins: [Coin]) -> [Coin] {
        coins.sorted { Double($0.percentChange24h) ?? 0 > Double($1.percentChange24h) ?? 0 }
    }
    
    private func sortByVolume(_ coins: [Coin]) -> [Coin] {
        coins.sorted { $0.volume24 > $1.volume24 }
    }
    
}
