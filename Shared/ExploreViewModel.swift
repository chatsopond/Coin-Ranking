//
//  ExploreViewModel.swift
//  LMWN Coin 2
//
//  Created by Chatsopon Deepateep on 15/6/2565 BE.
//

import SwiftUI
import os

enum ExploreViewFetchState: String {
    case ready, fetching, error
}

class ExploreViewModel: ObservableObject {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                        category: String(describing: ExploreViewModel.self))
    let coinAPI = CoinAPIRequestLoader()
    
    // MARK: - Published Variable
    @Published var fetchState: ExploreViewFetchState = .error
    @Published var coins = Set<Coin>()
    @Published var isRefreshing = false
    @Published var isFetching = false
    
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
    
    @MainActor
    func replaceCoins() async {
        
    }
    
    @MainActor
    func loadNextCoins() async {
        
    }
    
    // MARK: - Views
    
    @MainActor
    func pulling() {
        updateFetchState(to: .ready)
        pullDidRequest()
    }
    
    @MainActor
    func tryAgainDidPress() {
        updateFetchState(to: .ready)
        tryLoadCoins()
    }
    
    @MainActor
    func fetchStatusDidAppear() {
        print("fetchStatusDidAppear")
        tryLoadCoins()
    }
    
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
            await updateRefreshUIState(false)
            await updateFetchState(to: .ready)
        }
    }
    
    func tryLoadCoins(isReset: Bool = false) {
        guard fetchState == .ready else { return }
        Task {
            await updateFetchState(to: .fetching)
            await updateFetchUIState(true)
            do {
                var offset = coins.count
                if isReset {
                    offset = 0
                    await replaceCoins()
                }
                let coins = try await coinAPI.loadGetCoinsRequest(offset: offset)
                for coin in coins {
                    await insert(coin)
                }
            } catch {
                await updateFetchUIState(false)
                await updateFetchState(to: .error)
                return
            }
            await updateFetchUIState(false)
            await updateFetchState(to: .ready)
        }
    }
}
