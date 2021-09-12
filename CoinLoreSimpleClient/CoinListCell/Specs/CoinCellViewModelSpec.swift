//
//  CoinCellViewModelSpec.swift
//  CoinLoreSimpleClient
//
//  Created by Eliasz Sawicki on 12/09/2021.
//

import Foundation
import Quick
import Nimble
@testable import CoinLoreSimpleClient

class CoinCellViewModelSpec: QuickSpec {
    
    override func spec() {
        
        describe("CoinCellViewModel") {
            
            var builder: CoinBuilder!
            
            beforeEach {
                builder = CoinBuilder()
                    .with(id: "id")
                    .with(name: "Bitcoin")
                    .with(symbol: "BTC")
                    .withVolume24(volume24: 3400000000)
                    .with(priceUSD: "300")
                    .withPercentChange1(percentChange1: "-0.15")
                    .withPercentChange24(percentChange24: "2.4")
            }
            
            it("formats properly basic data") {
                let coin = builder.build()
                let sut = CoinCellViewModel(coin: coin, growthTrend: .rise)
                expect(sut.id) == coin.id
                expect(sut.name) == coin.name
                expect(sut.priceUSD) == "$300"
                expect(sut.symbol) == "(BTC)"
                expect(sut.volume24) == "VOL $3.4B"
                expect(sut.percentChange1h) == "-0.15%"
                expect(sut.percentChange24h) == "2.4%"
                expect(sut.isRisingTrend1h) == false
                expect(sut.isRisingTrend24h) == true
            }
            
            describe("volume24 formatting") {
                
                it("formats to B") {
                    let coin = builder.withVolume24(volume24: 3400000000).build()
                    let sut = CoinCellViewModel(coin: coin, growthTrend: .fall)
                    expect(sut.volume24) == "VOL $3.4B"
                }
                
                it("formats to M") {
                    let coin = builder.withVolume24(volume24: 123456789).build()
                    let sut = CoinCellViewModel(coin: coin, growthTrend: .fall)
                    expect(sut.volume24) == "VOL $123.5M"
                }
                
                it("formats to k") {
                    let coin = builder.withVolume24(volume24: 23456).build()
                    let sut = CoinCellViewModel(coin: coin, growthTrend: .fall)
                    expect(sut.volume24) == "VOL $23.5k"
                }
                
                it("no formatting added") {
                    let coin = builder.withVolume24(volume24: 123).build()
                    let sut = CoinCellViewModel(coin: coin, growthTrend: .fall)
                    expect(sut.volume24) == "VOL $123"
                }
                
            }
            
        }
        
    }
    
}
