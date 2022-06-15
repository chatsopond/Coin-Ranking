//
//  CoinDetailViewModel.swift
//  LMWN Coin 2 Tests
//
//  Created by Chatsopon Deepateep on 15/6/2565 BE.
//

import SwiftUI
import os

enum CoinDetailViewState {
    case ready, busy, complete, error
}

class CoinDetailViewModel: ObservableObject {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                        category: String(describing: CoinDetailViewModel.self))
    @Published var viewState: CoinDetailViewState = .ready
    @Published var coinDetail: CoinDetail?
    @MainActor
    func updateViewState(to newState: CoinDetailViewState) {
        viewState = newState
    }
    @MainActor
    func updateCoinDetail(_ newCoinDetail: CoinDetail) {
        coinDetail = newCoinDetail
    }
    let coinApi = CoinAPIRequestLoader()
    func fetch(for uuid: String) {
        guard viewState == .ready else { return }
        Task {
            await updateViewState(to: .busy)
            guard let coinDetail = try? await coinApi.loadGetCoinDetailRequest(uuid: uuid) else {
                await updateViewState(to: .error)
                return
            }
            await updateViewState(to: .complete)
            await updateCoinDetail(coinDetail)
        }
    }
}
