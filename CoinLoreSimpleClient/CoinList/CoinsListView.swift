//
//  ContentView.swift
//  CoinLoreSimpleClient
//
//  Created by Eliasz Sawicki on 10/09/2021.
//

import SwiftUI

struct CoinsListView<ViewModel: CoinsListViewModel>: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var coinsList: some View {
        VStack {
            Picker(selection: $viewModel.sortingCriteria, label: Text("Sorting criteria")) {
                ForEach(SortingCriteria.allCases) { sort in
                    Text(sort.displayText()).tag(sort)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            List(viewModel.coins) { coinViewModel in
                CoinListCell(viewModel: coinViewModel)
            }
        }
    }
    
    var placeholder: some View {
        ProgressView()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.coins.isEmpty {
                    placeholder
                } else {
                    coinsList
                }
            }.navigationTitle(Text("CoinLore"))
            .alert(isPresented: $viewModel.isAlertPresenter, content: {
                Alert(title: Text("Error"),
                      message: Text("Failed to load coins"),
                      dismissButton: .default(Text("Reload"), action: viewModel.reloadData))
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: viewModel.didAppear)
        .onDisappear(perform: viewModel.didDisappear)
    }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
        CoinsListView(viewModel: FakeWithItemsCoinsListViewModel())
        CoinsListView(viewModel: FakeNoItemsCoinsListViewModel())
    }
  }
}

class FakeNoItemsCoinsListViewModel: CoinsListViewModel {
    
    var coins: [CoinCellViewModel] = []
    var sortingCriteria: SortingCriteria = .volume
    var isAlertPresenter: Bool = false
    func didAppear() {}
    func didDisappear() {}
    func reloadData() {}
}

class FakeWithItemsCoinsListViewModel: CoinsListViewModel {
    var coins: [CoinCellViewModel] = [
        CoinCellViewModel(coin: CoinBuilder()
                            .with(id: "1")
                            .with(name: "Bitcoin").build(), growthTrend: .fall),
        CoinCellViewModel(coin: CoinBuilder()
                            .with(id: "2")
                            .with(name: "Doge").build(), growthTrend: .rise),
        CoinCellViewModel(coin: CoinBuilder()
                            .with(id: "3")
                            .with(name: "Avalanche").build(), growthTrend: .noChange),
    ]
    var sortingCriteria: SortingCriteria = .volume
    var isAlertPresenter: Bool = false
    func didAppear() {}
    func didDisappear() {}
    func reloadData() {}
}
