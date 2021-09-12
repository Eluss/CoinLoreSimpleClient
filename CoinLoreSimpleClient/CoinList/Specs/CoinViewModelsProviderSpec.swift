//
//  CoinViewModelsProviderSpec.swift
//  CoinLoreSimpleClientTests
//
//  Created by Eliasz Sawicki on 12/09/2021.
//

import Foundation
import Quick
import Nimble
@testable import CoinLoreSimpleClient

class DefaultCoinViewModelsProviderSpec: QuickSpec {
    
    override func spec() {
        
        describe("DefaultCoinViewModelsProvider") {
            
            var coinSorter: MockCoinSorter!
            var sut: DefaultCoinViewModelsProvider!
            
            beforeEach {
                coinSorter = MockCoinSorter()
                sut = DefaultCoinViewModelsProvider(coinSorter: coinSorter)
            }
            
            describe("coinsViewModels") {
                
                context("no last coins") {
                    
                    let coins = [CoinBuilder().with(name: "A").build(),
                                 CoinBuilder().with(name: "B").build(),
                                 CoinBuilder().with(name: "C").build()]
                    let expectedCoins = coins.map {
                        CoinCellViewModel(coin: $0, growthTrend: .noChange)
                    }
                    var resultCoins: [CoinCellViewModel] = []
                    beforeEach {
                        coinSorter.returnedSort = coins
                        resultCoins = sut.coinsViewModels(currentCoins: coins, lastCoins: [], sortingCriteria: .name)
                    }
                    
                    it("sorts coins") {
                        coinSorter.verifyCall(withIdentifier: coinSorter.idSort, arguments: [coins, SortingCriteria.name])
                    }
                    
                    it("returns view models with no change growth trend") {
                        expect(resultCoins) == expectedCoins
                    }
                }
                
                context("has last coins") {
                    let growthTrend: [String: GrowthTrend] = ["A": .fall,
                                                              "B": .noChange,
                                                              "C": .rise]
                    let coins = [CoinBuilder()
                                    .with(id: "1")
                                    .with(name: "A")
                                    .with(priceUSD: "1").build(),
                                 CoinBuilder()
                                    .with(id: "2")
                                    .with(name: "B")
                                    .with(priceUSD: "2").build(),
                                 CoinBuilder()
                                    .with(id: "3")
                                    .with(name: "C")
                                    .with(priceUSD: "3").build()]
                    let lastCoins = [CoinBuilder()
                                        .with(id: "1")
                                        .with(name: "A")
                                        .with(priceUSD: "3").build(),
                                 CoinBuilder()
                                    .with(id: "2")
                                    .with(name: "B")
                                    .with(priceUSD: "2").build(),
                                 CoinBuilder()
                                    .with(id: "3")
                                    .with(name: "C")
                                    .with(priceUSD: "1").build()]
                    
                    let expectedCoins = coins.map {
                        CoinCellViewModel(coin: $0, growthTrend: growthTrend[$0.name] ?? .noChange)
                    }
                    var resultCoins: [CoinCellViewModel] = []
                    
                    beforeEach {
                        coinSorter.returnedSort = coins
                        resultCoins = sut.coinsViewModels(currentCoins: coins, lastCoins: lastCoins, sortingCriteria: .name)
                    }
                    
                    it("sorts coins") {
                        coinSorter.verifyCall(withIdentifier: coinSorter.idSort, arguments: [coins, SortingCriteria.name])
                    }
                    
                    it("returns view models with no change growth trend") {
                        expect(resultCoins) == expectedCoins
                    }
                }
                
            }
            
        }
        
    }
    
}
