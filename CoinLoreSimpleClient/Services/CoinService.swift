//
//  CryptoService.swift
//  CoinLoreSimpleClient
//
//  Created by Eliasz Sawicki on 10/09/2021.
//

import Foundation
import Combine

enum CryptoServiceError: Error {
    case unknown
}

protocol CoinService {
    func fetchCrypto() -> AnyPublisher<[Coin], CryptoServiceError>
}

class RESTCoinService: CoinService {
    
    private let apiClient: ApiClient
    
    init(apiClient: ApiClient = URLSession.shared) {
        self.apiClient = apiClient
    }
    
    func fetchCrypto() -> AnyPublisher<[Coin], CryptoServiceError> {
        guard let url = URL(string: "https://api.coinlore.com/api/tickers/?limit=20") else {
            return Fail(outputType: [Coin].self, failure: CryptoServiceError.unknown)
                .eraseToAnyPublisher()
        }
        return apiClient
            .performRequest(url: url)
            .map(\.data)
            .decode(type: CoinsResponse.self, decoder: JSONDecoder())
            .map(\.coins)
            .mapError { _ in CryptoServiceError.unknown }
            .eraseToAnyPublisher()
    }
    
}
