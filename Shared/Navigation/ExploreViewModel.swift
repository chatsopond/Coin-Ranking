//
//  ExploreViewModel.swift
//  LMWN Coin 2
//
//  Created by Chatsopon Deepateep on 15/6/2565 BE.
//

import SwiftUI
import os
import Combine

enum ExploreViewFetchState: String {
    case ready, fetching, error
}

class ExploreViewModel: ObservableObject {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                        category: String(describing: ExploreViewModel.self))
    let coinAPI = CoinAPIRequestLoader()
    
    // MARK: - Published Variable
    @Published var fetchState: ExploreViewFetchState = .ready
    @Published var coins = Set<Coin>()
    @Published var isRefreshing = false
    @Published var isFetching = false
    @Published var invitePositon: [Int] = []
    
    // MARK: Search Systems
    let queue = DispatchQueue(label: String(describing: ExploreViewModel.self))
    var deboucedSearch = PassthroughSubject<Void, Never>()
    var searchCancellable: AnyCancellable?
    func search(query: String) {
        searchCancellable = deboucedSearch
            .timeout(.seconds(1), scheduler: queue)
            .sink(receiveCompletion: { [weak self] _ in
                // Debounced
                // Start call search
                self?.tryLoadCoins(isForced: true, isReset: true, query: query)
            }, receiveValue: { _ in
                // Nothing to do
            })
    }
    
    // MARK: Update Invitation Position
    @MainActor
    func updateInvitePosition() {
        let maximum = coins.count
        /// invitation position
        var n = 5
        invitePositon.removeAll()
        while n < (maximum + invitePositon.count) {
            /// the position offset according to the number of invitation cards inserted previously.
            let offset = invitePositon.count
            invitePositon.append(n - offset)
            n *= 2
        }
        logger.log("Invitation count: \(self.invitePositon.count), \(self.invitePositon), max: \(self.coins.count)")
    }
    
    // MARK: - Update Published Variable
    @MainActor
    func updateFetchState(to newState: ExploreViewFetchState) {
        logger.log("Update FetchState to \(newState.rawValue)")
        fetchState = newState
    }
    
    @MainActor
    func clearCoins() {
        coins.removeAll()
    }
    
    @MainActor
    func insert(_ coin: Coin) {
        coins.insert(coin)
    }
    
    @MainActor
    func updateRefreshUIState(_ to: Bool) {
        isRefreshing = to
    }
    
    @MainActor
    func updateFetchUIState(_ to: Bool) {
        isFetching = to
    }
    
    // MARK: - View Calling
    
    @MainActor
    func pulling() {
        updateFetchState(to: .ready)
        pullDidRequest()
    }
    
    @MainActor
    func tryAgainDidPress() {
        updateFetchState(to: .ready)
        tryLoadCoins(query: "")
    }
    
    @MainActor
    func fetchStatusDidAppear(query: String) {
        tryLoadCoins(query: query)
    }
    
    // MARK: - Functions
    
    func pullDidRequest() {
        guard fetchState == .ready else { return }
        tryRefreshCoin()
    }
    
    func tryRefreshCoin() {
        Task {
            await updateFetchState(to: .fetching)
            await updateRefreshUIState(true)
            do {
                let coins = try await coinAPI.loadGetCoinsRequest(offset: 0)
                await clearCoins()
                for coin in coins {
                    await insert(coin)
                }
            } catch {
                await updateRefreshUIState(false)
                await updateFetchState(to: .error)
                return
            }
            await updateInvitePosition()
            await updateRefreshUIState(false)
            await updateFetchState(to: .ready)
        }
    }
    
    func tryLoadCoins(isForced: Bool = false, isReset: Bool = false, query: String) {
        guard fetchState == .ready || isForced else { return }
        Task {
            await updateFetchState(to: .fetching)
            await updateFetchUIState(true)
            do {
                var offset = coins.count
                if isReset {
                    offset = 0
                    await clearCoins()
                }
                let coins = try await coinAPI.loadGetCoinsRequest(offset: offset, search: query)
                for coin in coins {
                    await insert(coin)
                }
            } catch {
                await updateFetchUIState(false)
                await updateFetchState(to: .error)
                return
            }
            await updateInvitePosition()
            await updateFetchUIState(false)
            await updateFetchState(to: .ready)
        }
    }
}
