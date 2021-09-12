//
//  MockCoinSorter.swift
//  CoinLoreSimpleClientTests
//
//  Created by Eliasz Sawicki on 12/09/2021.
//

import Foundation
import Mimus
@testable import CoinLoreSimpleClient

class MockCoinSorter: CoinSorter, Mock {
    
    let idSort = "idSort"
    var storage = Storage()
    var returnedSort: [Coin] = []
    
    override func sort(coins: [Coin], criteria: SortingCriteria) -> [Coin] {
        recordCall(withIdentifier: idSort, arguments: [coins, criteria])
        return returnedSort
    }
}
