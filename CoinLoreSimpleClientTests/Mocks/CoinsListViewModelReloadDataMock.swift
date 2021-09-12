//
//  CoinsListViewModelReloadDataMock.swift
//  CoinLoreSimpleClientTests
//
//  Created by Eliasz Sawicki on 12/09/2021.
//

import Foundation
import Mimus
@testable import CoinLoreSimpleClient

class CoinsListViewModelReloadDataMock: DefaultCoinsListViewModel, Mock {
    
    let idReloadData = "idReloadData"
    var storage = Storage()
    
    override func reloadData() {
        recordCall(withIdentifier: idReloadData)
    }
}


