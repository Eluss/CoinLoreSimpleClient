//
//  MockCryptoService.swift
//  CoinLoreSimpleClientTests
//
//  Created by Eliasz Sawicki on 12/09/2021.
//

import Foundation
import Mimus
import Combine
@testable import CoinLoreSimpleClient

class MockCryptoService: CoinService, Mock {
    
    let idFetchCrypto = "idFetchCrypto"
    var storage: Storage = Storage()
    
    var promise: ((Result<[Coin], CryptoServiceError>) -> Void)?
    
    func fetchCrypto() -> AnyPublisher<[Coin], CryptoServiceError> {
        recordCall(withIdentifier: idFetchCrypto)
        return Deferred {
            Future { promise in
                self.promise = promise
            }
        }.eraseToAnyPublisher()
    }
    
}
