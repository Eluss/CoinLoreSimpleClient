//
//  CoinLoreSimpleClientApp.swift
//  CoinLoreSimpleClient
//
//  Created by Eliasz Sawicki on 12/09/2021.
//

import SwiftUI

@main
struct CoinLoreSimpleClientApp: App {
    var body: some Scene {
        WindowGroup {
            CoinsListView(viewModel: DefaultCoinsListViewModel())
        }
    }
}
