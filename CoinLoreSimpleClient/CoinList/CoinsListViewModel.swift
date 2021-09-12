//
//  CoinsListViewModel.swift
//  CoinLoreSimpleClient
//
//  Created by Eliasz Sawicki on 10/09/2021.
//

import Foundation
import Combine
import CombineSchedulers

protocol CoinsListViewModel: ObservableObject {
    var coins: [CoinCellViewModel] { get }
    var sortingCriteria: SortingCriteria { get set }
    var isAlertPresenter: Bool { get set }
    func reloadData()
    func didAppear()
    func didDisappear()
}

class DefaultCoinsListViewModel: CoinsListViewModel {
        
    private var lastCoins: [Coin] = []
    private var currentCoins: [Coin] = []
    @Published private(set) var coins: [CoinCellViewModel] = []
    @Published var sortingCriteria: SortingCriteria = .name
    @Published var isAlertPresenter: Bool = false
    
    private var timerCancellable: AnyCancellable?
    private var cancellables: [AnyCancellable] = []
    private let service: CoinService
    private let coinViewModelsProvider: CoinViewModelsProvider
    private var coinsReloadTimer: Timer?
    private let receiveOnScheduler: AnySchedulerOf<DispatchQueue>
    private let timerScheduler: AnySchedulerOf<DispatchQueue>
    
    init(service: CoinService = RESTCoinService(),
         coinViewModelsProvider: CoinViewModelsProvider = DefaultCoinViewModelsProvider(),
         receiveOnScheduler: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler(),
         timerScheduler: AnySchedulerOf<DispatchQueue> = DispatchQueue.global().eraseToAnyScheduler()) {
        self.service = service
        self.coinViewModelsProvider = coinViewModelsProvider
        self.receiveOnScheduler = receiveOnScheduler
        self.timerScheduler = timerScheduler
        observeSortingCriteriaChanges()
        
    }
    
    private func observeSortingCriteriaChanges() {
        $sortingCriteria
            .dropFirst()
            .receive(on: receiveOnScheduler)
            .sink {[weak self] sorting in
            guard let self = self else { return }
            self.coins = self.coinViewModelsProvider.coinsViewModels(currentCoins: self.currentCoins,
                                                                     lastCoins: self.lastCoins,
                                                                     sortingCriteria: sorting)
            }.store(in: &cancellables)
    }
    
    func reloadData() {
        fetchCoins()
    }
    
    func didAppear() {
        reloadData()
        scheduleCoinsReload()
    }
    
    func didDisappear() {
        timerCancellable?.cancel()
    }
    
    private func scheduleCoinsReload() {
        timerCancellable = Publishers.Timer(every: 30, scheduler: timerScheduler)
            .autoconnect()
            .sink {[weak self] _ in
            self?.reloadData()
        }
    }
    
    private func fetchCoins() {
        service
            .fetchCrypto()
            .receive(on: receiveOnScheduler)
            .sink {[weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure:
                    self.isAlertPresenter = true
                case .finished: break
                }
            } receiveValue: {[weak self] coins in
                guard let self = self else { return }
                self.handleReceivedCoins(coins)
            }.store(in: &cancellables)
    }
    
    private func handleReceivedCoins(_ newCoins: [Coin]) {
        self.lastCoins = self.currentCoins
        self.currentCoins = newCoins
        self.coins = self.coinViewModelsProvider.coinsViewModels(currentCoins: self.currentCoins,
                                                                 lastCoins: self.lastCoins,
                                                                 sortingCriteria: self.sortingCriteria)
}

}
