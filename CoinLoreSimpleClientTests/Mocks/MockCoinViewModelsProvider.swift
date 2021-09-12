//
//  MockCoinViewModelsProvider.swift
//  CoinLoreSimpleClientTests
//
//  Created by Eliasz Sawicki on 12/09/2021.
//

import Foundation
import Mimus
@testable import CoinLoreSimpleClient

class MockCoinViewModelsProvider: CoinViewModelsProvider, Mock {
    
    let idCoinsViewModels = "idCoinsViewModels"
    var storage = Storage()
    var returnedCoinCellViewModels: [CoinCellViewModel] = []
    
    func coinsViewModels(currentCoins: [Coin], lastCoins: [Coin], sortingCriteria: SortingCriteria) -> [CoinCellViewModel] {
        recordCall(withIdentifier: idCoinsViewModels, arguments: [currentCoins, lastCoins, sortingCriteria])
        return returnedCoinCellViewModels
    }
}
