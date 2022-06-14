//
//  ExploreView.swift
//  LMWN Coin 2
//
//  Created by Chatsopon Deepateep on 15/6/2565 BE.
//

import SwiftUI
import os

struct ExploreView: View {
    
    @StateObject var viewModel = ExploreViewModel()
    @State var hasScrolled = false
    
    var body: some View {
        ZStack(alignment: .top) {
            if viewModel.isRefreshing {
                LoadingView(style: .button)
                    .padding(.top, 20)
                    .transition(.opacity)
                    .zIndex(100)
            }
            scrollView
        }
    }
    
    var scrollView: some View {
        ScrollView {
            scrollDetection
            LazyVStack {
                ForEach(Array(viewModel.coins)) { coin in
                    CoinCard(type: .row, coin: coin)
                }
                
                // Bottom
                Color.clear.frame(height: 80)
                    .overlay(
                        fetchStatus
                        .onAppear {
                            viewModel.fetchStatusDidAppear()
                        }
                    )
            }
            .padding()
        }
        .coordinateSpace(name: "scroll")
    }
    
    @ViewBuilder
    var fetchStatus: some View {
        switch viewModel.fetchState {
        case .error:
            VStack {
                Text("Cloud not load data")
                Button("Try again") {
                    viewModel.tryAgainDidPress()
                }
                .font(.body.weight(.semibold))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 21)
            .frame(height: 80)
        default:
            if viewModel.isFetching {
                LoadingView(style: .plain)
                    .frame(height: 80)
            }
        }
    }
    
    var scrollDetection: some View {
        GeometryReader { proxy in
            let offset = proxy.frame(in: .named("scroll")).minY
            Text("\(offset)").preference(key: ScrollPreferenceKey.self, value: offset)
        }
        .onPreferenceChange(ScrollPreferenceKey.self) { value in
            withAnimation(.easeInOut) {
                hasScrolled = value > 80
            }
        }
        .onChange(of: hasScrolled) { newValue in
            if hasScrolled { viewModel.pulling() }
        }
    }
}

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
        Task {
            await updateRefreshUIState(true)
            try await Task.sleep(nanoseconds: 1_000_000_000)
            await replaceCoins()
            await updateRefreshUIState(false)
        }
    }
    
    
    func tryLoadCoins() {
        guard fetchState == .ready else { return }
        Task {
            await updateFetchState(to: .fetching)
            await updateFetchUIState(true)
            do {
                let coins = try await coinAPI.loadGetCoinsRequest(offset: coins.count)
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

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
