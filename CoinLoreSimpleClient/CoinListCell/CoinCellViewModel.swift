//
//  CoinCellViewModel.swift
//  CoinCellViewModel
//
//  Created by Eliasz Sawicki on 11/09/2021.
//

import Foundation

enum GrowthTrend {
    case rise
    case fall
    case noChange
}

struct CoinCellViewModel: Identifiable, Equatable {
    
    private let coin: Coin
    
    var id: String {
        return coin.id
    }
    
    var name: String {
        coin.name
    }
    var priceUSD: String {
        "$" + coin.priceUSD
    }
    var symbol: String {
        "(\(coin.symbol))"
    }
    var volume24: String {
        "VOL $" + formatPoints(coin.volume24)
    }
    var percentChange1h: String {
        coin.percentChange1h + "%"
    }
    var percentChange24h: String {
        coin.percentChange24h + "%"
    }
    
    let growthTrend: GrowthTrend
    
    var isRisingTrend1h: Bool {
        isRisingTrend(for: coin.percentChange1h)
    }
    
    var isRisingTrend24h: Bool {
        isRisingTrend(for: coin.percentChange24h)
    }
    
    init(coin: Coin, growthTrend: GrowthTrend) {
        self.coin = coin
        self.growthTrend = growthTrend
    }
    
    func isRisingTrend(for value: String) -> Bool {
        if let percent = Double(value) {
            return percent >= 0
        }
        return false
    }
    
    private func formatPoints(_ num: Double) -> String {
        var thousandNum = num/1000
        var millionNum = num/1000000
        var billionNum = num/1000000000
        if num >= 1000 && num < 1000000{
            if(floor(thousandNum) == thousandNum){
                return("\(Int(thousandNum))k")
            }
            return("\(thousandNum.roundToPlaces(places: 1))k")
        }
        if num > 1000000 && num < 1000000000 {
            if(floor(millionNum) == millionNum){
                return("\(Int(thousandNum))k")
            }
            return ("\(millionNum.roundToPlaces(places: 1))M")
        }
        if num > 1000000000 {
            if(floor(billionNum) == billionNum){
                return("\(Int(thousandNum))k")
            }
            return ("\(billionNum.roundToPlaces(places: 1))B")
        }
        else{
            if(floor(num) == num){
                return ("\(Int(num))")
            }
            return ("\(num)")
        }

    }
    
}

extension Double {
    /// Rounds the double to decimal places value
    mutating func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Darwin.round(self * divisor) / divisor
    }
}
