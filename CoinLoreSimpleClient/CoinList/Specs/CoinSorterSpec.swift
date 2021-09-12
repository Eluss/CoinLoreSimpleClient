//
//  CoinSorterSpec.swift
//  CoinLoreSimpleClientTests
//
//  Created by Eliasz Sawicki on 12/09/2021.
//

import Foundation
import Quick
import Nimble
@testable import CoinLoreSimpleClient

class CoinSorterSpec: QuickSpec {
    
    override func spec() {
        
        describe("CoinSorter") {
            
            var sut: CoinSorter!
            
            beforeEach {
                sut = CoinSorter()
            }
            
            describe("sort by name") {
    
                let coins = [CoinBuilder().with(name: "C").build(),
                             CoinBuilder().with(name: "A").build(),
                             CoinBuilder().with(name: "B").build()]
                
                it("returns sorted coins") {
                    let sorted = sut.sort(coins: coins, criteria: .name)
                    expect(sorted) == [CoinBuilder().with(name: "A").build(),
                                      CoinBuilder().with(name: "B").build(),
                                      CoinBuilder().with(name: "C").build()]
                }

            }
            
            describe("sort by percent") {
    
                let coins = [CoinBuilder().withPercentChange24(percentChange24: "1").build(),
                             CoinBuilder().withPercentChange24(percentChange24: "3").build(),
                             CoinBuilder().withPercentChange24(percentChange24: "2").build()]
                
                it("returns sorted coins") {
                    let sorted = sut.sort(coins: coins, criteria: .percentChange)
                    expect(sorted) == [CoinBuilder().withPercentChange24(percentChange24: "3").build(),
                                       CoinBuilder().withPercentChange24(percentChange24: "2").build(),
                                       CoinBuilder().withPercentChange24(percentChange24: "1").build()]
                }

            }
            
            describe("sort by volume") {
    
                let coins = [CoinBuilder().withVolume24(volume24: 3).build(),
                             CoinBuilder().withVolume24(volume24: 1).build(),
                             CoinBuilder().withVolume24(volume24: 2).build()]
                
                it("returns sorted coins") {
                    let sorted = sut.sort(coins: coins, criteria: .volume)
                    expect(sorted) == [CoinBuilder().withVolume24(volume24: 3).build(),
                                       CoinBuilder().withVolume24(volume24: 2).build(),
                                       CoinBuilder().withVolume24(volume24: 1).build()]
                }

            }
            
        }
        
    }
    
}
