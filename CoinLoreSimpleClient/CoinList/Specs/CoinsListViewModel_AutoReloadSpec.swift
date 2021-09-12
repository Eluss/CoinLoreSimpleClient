//
//  CoinsListViewModelAutoReloadSpec.swift
//  CoinLoreSimpleClientTests
//
//  Created by Eliasz Sawicki on 12/09/2021.
//

import Foundation
import Quick
import Nimble
import Mimus
import CombineSchedulers
@testable import CoinLoreSimpleClient

class CoinsListViewModelAutoReloadSpec: QuickSpec {
    
    override func spec() {
        
        describe("CoinsListViewModelAutoReload") {
            
            var cryptoService: MockCryptoService!
            var coinViewModelsProvider: MockCoinViewModelsProvider!
            var sut: CoinsListViewModelReloadDataMock!
            var timerScheduler: TestSchedulerOf<DispatchQueue>!
            beforeEach {
                coinViewModelsProvider = MockCoinViewModelsProvider()
                cryptoService = MockCryptoService()
                timerScheduler = DispatchQueue.test
                sut = CoinsListViewModelReloadDataMock(service: cryptoService,
                                                coinViewModelsProvider: coinViewModelsProvider,
                                                receiveOnScheduler: DispatchQueue.immediate.eraseToAnyScheduler(),
                                                timerScheduler: timerScheduler.eraseToAnyScheduler())
            }
            
            describe("did appear") {
                
                beforeEach {
                    sut.didAppear()
                }
                
                it("fetches data") {
                    sut.verifyCall(withIdentifier: sut.idReloadData)
                }
                
            }
            
            describe("did disappear") {
                
                beforeEach {
                    sut.didAppear()
                    sut.storage = Storage()
                    sut.didDisappear()
                    timerScheduler.advance(by: 30)
                }
                
                it("does not reload data after disappearing") {
                    sut.verifyCall(withIdentifier: sut.idReloadData, mode: .never)
                }
            }
            
            describe("auto data reload") {
                
                beforeEach {
                    sut.didAppear()
                    sut.storage = Storage()
                }
                
                it("has no auto reloads") {
                    sut.verifyCall(withIdentifier: sut.idReloadData, mode: .never)
                }
                
                context("first timer interval passes by") {
                    beforeEach {
                        timerScheduler.advance(by: 30)
                    }
                    
                    it("reloads data") {
                        sut.verifyCall(withIdentifier: sut.idReloadData)
                    }
                    
                    context("second timer interval passes by") {
                        beforeEach {
                            timerScheduler.advance(by: 30)
                        }
                        
                        it("reloads data") {
                            sut.verifyCall(withIdentifier: sut.idReloadData, mode: .times(2))
                        }
                    }
                    
                }
                
            }
            
        }
    }
}
