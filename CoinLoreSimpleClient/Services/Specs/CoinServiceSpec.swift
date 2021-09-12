//
//  CoinServiceSpec.swift
//  CoinLoreSimpleClientTests
//
//  Created by Eliasz Sawicki on 12/09/2021.
//

import Foundation
import Quick
import Nimble
import Combine
import Mimus
@testable import CoinLoreSimpleClient

class CoinServiceSpec: QuickSpec {
    
    override func spec() {
        
        describe("CoinService") {
            
            var completionClosure: MockClosure<Subscribers.Completion<CryptoServiceError>>!
            var coinsClosure: MockClosure<[Coin]>!
            var apiClient: MockApiClient!
            var sut: RESTCoinService!
            
            beforeEach {
                completionClosure = MockClosure<Subscribers.Completion<CryptoServiceError>>()
                coinsClosure = MockClosure<[Coin]>()
                apiClient = MockApiClient()
                sut = RESTCoinService(apiClient: apiClient)
            }
            
            describe("fetch crypto") {

                describe("used url") {
                    beforeEach {
                        _ = sut.fetchCrypto().sink(
                            receiveCompletion: completionClosure.closure,
                            receiveValue: coinsClosure.closure)
                    }
                    
                    it("has correct request url") {
                        let expectedURL = URL(string: "https://api.coinlore.com/api/tickers/?limit=20")!
                        apiClient.verifyCall(withIdentifier: apiClient.idPerformRequest, arguments: [expectedURL])
                    }
                }
                                
                context("Succeeds request") {
                    
                    beforeEach {
                        apiClient.returnedPerformRequest = Just((CoinServiceFakes.fakeCoinsJSON, URLResponse.fake()))
                            .setFailureType(to: URLError.self)
                            .eraseToAnyPublisher()
                        
                        _ = sut.fetchCrypto().sink(
                            receiveCompletion: completionClosure.closure,
                            receiveValue: coinsClosure.closure)

                    }
                    
                    it("finishes request") {
                        expect(completionClosure.valueInClosure) == Subscribers.Completion.finished
                    }
                    
                    it("returns coins from response") {
                        expect(coinsClosure.valueInClosure) == CoinServiceFakes.fakeCoinsJSONModels
                    }
                }
                
                context("Failed decoding") {
                    beforeEach {
                        apiClient.returnedPerformRequest = Just((CoinServiceFakes.invalidJSON, URLResponse.fake()))
                            .setFailureType(to: URLError.self)
                            .eraseToAnyPublisher()
                        
                        _ = sut.fetchCrypto().sink(
                            receiveCompletion: completionClosure.closure,
                            receiveValue: coinsClosure.closure)

                    }
                    
                    it("fails with error") {
                        expect(completionClosure.valueInClosure) == Subscribers.Completion.failure(.unknown)
                    }
                    
                    it("returns no coins") {
                        expect(coinsClosure.valueInClosure).to(beNil())
                    }
                }
                
                context("Failed request") {
                    
                    beforeEach {
                        apiClient.returnedPerformRequest = Fail(outputType: URLSession.DataTaskPublisher.Output.self, failure: URLError(.badURL)).eraseToAnyPublisher()
                        _ = sut.fetchCrypto().sink(
                            receiveCompletion: completionClosure.closure,
                            receiveValue: coinsClosure.closure)

                    }
                    
                    it("returns unknown crypto service error") {
                        expect(completionClosure.valueInClosure) == Subscribers.Completion.failure(CryptoServiceError.unknown)
                    }
                    
                    it("no coins received") {
                        expect(coinsClosure.valueInClosure).to(beNil())
                    }
                    
                }
            }
            
        }
        
    }
    
}

extension URLResponse {
    
    static func fake() -> URLResponse {
        return URLResponse(url: URL(string: "www.foo.bar")!, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
}

struct CoinServiceFakes {
    static let invalidJSON = "".data(using: .utf8)!
    
    static let fakeCoinsJSONModels = [Coin(id: "90", symbol: "BTC", name: "Bitcoin", priceUSD: "45310.36", percentChange24h: "-2.17", percentChange1h: "-0.59", volume24: 30804184045.37688),
                         Coin(id: "80", symbol: "ETH", name: "Ethereum", priceUSD: "3287.29", percentChange24h: "-4.62", percentChange1h: "-0.83", volume24: 19336752520.7633)
    ]
    
    static let fakeCoinsJSON = """
                {
                "data": [
                {
                "id": "90",
                "symbol": "BTC",
                "name": "Bitcoin",
                "nameid": "bitcoin",
                "rank": 1,
                "price_usd": "45310.36",
                "percent_change_24h": "-2.17",
                "percent_change_1h": "-0.59",
                "percent_change_7d": "-8.37",
                "price_btc": "1.00",
                "market_cap_usd": "849984291726.44",
                "volume24": 30804184045.37688,
                "volume24a": 32560054966.414318,
                "csupply": "18759159.00",
                "tsupply": "18759159",
                "msupply": "21000000"
                },
                {
                "id": "80",
                "symbol": "ETH",
                "name": "Ethereum",
                "nameid": "ethereum",
                "rank": 2,
                "price_usd": "3287.29",
                "percent_change_24h": "-4.62",
                "percent_change_1h": "-0.83",
                "percent_change_7d": "-12.71",
                "price_btc": "0.072496",
                "market_cap_usd": "383736480268.73",
                "volume24": 19336752520.7633,
                "volume24a": 22997480204.55517,
                "csupply": "116733553.00",
                "tsupply": "116733553",
                "msupply": ""
                }
                ],
                "info": {
                "coins_num": 6110,
                "time": 1631306761
                }
                }
                """.data(using: .utf8)!

}
