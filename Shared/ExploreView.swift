//
//  ExploreView.swift
//  LMWN Coin 2
//
//  Created by Chatsopon Deepateep on 15/6/2565 BE.
//

import SwiftUI

struct ExploreView: View {
    
    @StateObject var viewModel = ExploreViewModel()
    @State var hasScrolled = false
    @State var searchText = ""
    var sortedCoins: [Coin] {
        Array(viewModel.coins).sorted{ $0.rank < $1.rank }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            if viewModel.isRefreshing {
                LoadingView(style: .button)
                    .padding(.top, 20)
                    .transition(.opacity)
                    .zIndex(100)
            }
            content
        }
        .animation(.default, value: viewModel.isFetching)
        .animation(.default, value: viewModel.isRefreshing)
    }
    
    var content: some View {
        VStack(spacing: 16) {
            searchField
            VStack(spacing: 0) {
                Divider()
                scrollView
            }
        }
    }
    
    var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.searchPlaceholder)
            TextField("Search", text: $searchText)
            Button {
                searchText = ""
            } label: {
                Image(systemName: "xmark.circle.fill")
            }
            .foregroundColor(.searchPlaceholder)
            .disabled(searchText.isEmpty)
            .opacity(searchText.isEmpty ? 0 : 1)
        }
        .padding(16)
        .background(Color.searchBackground)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(16)
    }
    
    var scrollView: some View {
        ScrollView {
            scrollDetection
            VStack(alignment: .leading, spacing: 0) {
                listWithoutTopRank
            }
            LazyVStack{
                // Bottom
                Color.clear.frame(height: 80)
                    .overlay(fetchStatus.onAppear{viewModel.fetchStatusDidAppear()})
            }
        }
        .coordinateSpace(name: "scroll")
    }
    
    
    var listWithoutTopRank: some View {
        LazyVStack(alignment: .leading, spacing: 12) {
            Text("Buy, sell and hold crypto")
                .fontWeight(.semibold)
                .padding(.horizontal, 16)
            ForEach(Array(sortedCoins.enumerated()), id: \.element) { i, coin in
                CoinCard(type: .row, coin: coin)
            }
        }
        .padding(.horizontal, 8)
    }
    
    @ViewBuilder
    var listWithTopRank: some View {
        if sortedCoins.count > 3 {
            VStack(alignment: .leading, spacing: 12) {
                (
                    Text("Top ") +
                    Text("3 ")
                        .foregroundColor(.topRank) +
                    Text("rank crypto")
                )
                .fontWeight(.semibold)
                .padding(.horizontal, 16)
                HStack {
                    ForEach(0..<3) { i in
                        CoinCard(type: .column, coin: sortedCoins[i])
                    }
                }
                .padding(.horizontal, 15)
            }
            .padding(.bottom, 22)
        }
        LazyVStack(alignment: .leading, spacing: 12) {
            Text("Buy, sell and hold crypto")
                .fontWeight(.semibold)
                .padding(.horizontal, 16)
            ForEach(Array(sortedCoins.enumerated()), id: \.element) { i, coin in
                if i > 2 {
                    CoinCard(type: .row, coin: coin)
                }
            }
        }
        .padding(.horizontal, 8)
    }
    
    @ViewBuilder
    var fetchStatus: some View {
        switch viewModel.fetchState {
        case .error:
            VStack(spacing: 4) {
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
            Color.clear.preference(key: ScrollPreferenceKey.self, value: offset)
                .frame(height: 20)
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


struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
