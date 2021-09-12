//
//  ContentViewModelSpec.swift
//  ContentViewModelSpec
//
//  Created by Eliasz Sawicki on 11/09/2021.
//

import Foundation
import Quick
import Nimble
import Mimus
import Combine
import CombineSchedulers
@testable import CoinLoreSimpleClient

class CoinsListViewModelSpec: QuickSpec {
    
    override func spec() {
        
        describe("CoinsListViewModel") {
            
            var cryptoService: MockCryptoService!
            var coinViewModelsProvider: MockCoinViewModelsProvider!
            var sut: DefaultCoinsListViewModel!
            
            beforeEach {
                coinViewModelsProvider = MockCoinViewModelsProvider()
                cryptoService = MockCryptoService()
                sut = DefaultCoinsListViewModel(service: cryptoService,
                                                coinViewModelsProvider: coinViewModelsProvider,
                                                receiveOnScheduler: DispatchQueue.immediate.eraseToAnyScheduler())
            }
            
            describe("default state") {
                
                it("has name sorting set") {
                    expect(sut.sortingCriteria) == SortingCriteria.name
                }
                
                it("cells provider unused") {
                    coinViewModelsProvider.verifyCall(withIdentifier: coinViewModelsProvider.idCoinsViewModels,
                                                      arguments: .any,
                                                      mode: .never)
                }
                
                it("did not fetch data") {
                    cryptoService.verifyCall(withIdentifier: cryptoService.idFetchCrypto, arguments: .any, mode: .never)
                }
                
            }
            
            describe("sorting criteria changes") {
                
                let currentCoins = [CoinBuilder().with(name: "Bitcoin").build()]
                let lastCoins = [CoinBuilder().with(name: "Dogecoin").build()]
                let sortingCriteria = SortingCriteria.percentChange
                let createdCellViewModels = [CoinCellViewModel(coin: CoinBuilder().with(name: "afterCreation").build(), growthTrend: .fall)]
                
                beforeEach {
                    sut.reloadData()
                    cryptoService.promise?(.success(lastCoins))
                    sut.reloadData()
                    cryptoService.promise?(.success(currentCoins))
                    coinViewModelsProvider.returnedCoinCellViewModels = createdCellViewModels
                    sut.sortingCriteria = sortingCriteria
                }
                
                it("creates models with new sorting criteria") {
                    coinViewModelsProvider.verifyCall(withIdentifier: coinViewModelsProvider.idCoinsViewModels,
                                                      arguments: [currentCoins, lastCoins, sortingCriteria])
                }
                
                it("applies created cells") {
                    expect(sut.coins) == createdCellViewModels
                }
                
            }
            
            describe("reload data") {
                
                beforeEach {
                    sut.reloadData()
                }
                
                it("fetches data from crypto service") {
                    cryptoService.verifyCall(withIdentifier: cryptoService.idFetchCrypto)
                }
                
                context("fails to fetch data") {
                    beforeEach {
                        cryptoService.promise?(.failure(.unknown))
                    }
                    
                    it("does not create cell view models") {
                        coinViewModelsProvider.verifyCall(withIdentifier: coinViewModelsProvider.idCoinsViewModels,
                                                          arguments: .any,
                                                          mode: .never)
                    }
                    
                    it("displays an alert") {
                        expect(sut.isAlertPresenter).toEventually(beTrue())
                    }
                }
                
                context("succeeds to fetch data") {
                    let receivedCoins = [CoinBuilder().with(name: "Bitcoin").build(),
                                         CoinBuilder().with(name: "Dogecoin").build()]
                    let lastCoins: [Coin] = []
                    beforeEach {
                        coinViewModelsProvider.returnedCoinCellViewModels = [
                            CoinCellViewModel(coin: CoinBuilder().build(), growthTrend: .fall)
                        ]
                        cryptoService.promise?(.success(receivedCoins))
                    }
                    
                    it("creates cell view models based on received models") {
                        coinViewModelsProvider.verifyCall(withIdentifier: coinViewModelsProvider.idCoinsViewModels,
                                                          arguments: [receivedCoins, lastCoins, sut.sortingCriteria])
                    }
                    
                    it("applies created coins view models") {
                        let expected = coinViewModelsProvider.returnedCoinCellViewModels
                        expect(sut.coins).toEventually(equal(expected))
                        
                    }
                    
                    context("fetches coins again") {
                        
                        let lastCoins = [CoinBuilder().with(name: "Bitcoin").build(),
                                             CoinBuilder().with(name: "Dogecoin").build()]
                        let newCoins: [Coin] = [CoinBuilder().with(name: "Foo").build()]
                        
                        beforeEach {
                            coinViewModelsProvider.returnedCoinCellViewModels = [
                                CoinCellViewModel(coin: CoinBuilder().with(name: "new").build(), growthTrend: .fall)
                            ]
                            sut.reloadData()
                            cryptoService.promise?(.success(newCoins))
                        }
                        
                        it("creates cell view models based on new models and last coins") {
                            coinViewModelsProvider.verifyCall(withIdentifier: coinViewModelsProvider.idCoinsViewModels,
                                                              arguments: [newCoins, lastCoins, sut.sortingCriteria])
                        }
                        
                        it("applies new coins view models") {
                            let expected = coinViewModelsProvider.returnedCoinCellViewModels
                            expect(sut.coins).toEventually(equal(expected))
                            
                        }
                        
                    }
                    
                }
                
            }
            
            
            
        }
        
    }
    
}
