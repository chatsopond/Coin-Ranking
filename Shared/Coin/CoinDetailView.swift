//
//  CoinDetailView.swift
//  LMWN Coin 2
//
//  Created by Chatsopon Deepateep on 15/6/2565 BE.
//

import SwiftUI

struct CoinDetailView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.openURL) private var openURL
    @StateObject private var viewModel = CoinDetailViewModel()
    
    let coin: Coin
    
    var body: some View {
        ZStack {
            Color.clear
            content
            //header
        }
        .onAppear {
            viewModel.fetch(for: coin.uuid)
        }
    }
    
    @ViewBuilder
    var content: some View {
        switch viewModel.viewState {
        case .busy:
            ProgressView()
        case .error:
            VStack(spacing: 10) {
                Text("Could not load information")
                Button("Try Again") {
                    viewModel.updateViewState(to: .ready)
                    viewModel.fetch(for: coin.uuid)
                }
                .font(.body.weight(.semibold))
            }
        case .complete:
            fullDetailView
        default:
            EmptyView()
        }
    }
    
    /// The full detail view of the coin
    var fullDetailView: some View {
        VStack {
            headerInfo
            if let description = viewModel.coinDetail?.description {
                HTMLStringView(htmlContent: description)
            } else {
                Text("No Description")
                    .foregroundColor(.secondary)
                    .frame(maxHeight: .infinity)
            }
            Spacer()
            if let websiteUrl = viewModel.coinDetail?.websiteUrl {
                Divider()
                Button("Go To Website") { openURL(websiteUrl) }
                    .font(.body.weight(.semibold))
                    .padding([.horizontal, .top])
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var headerInfo: some View {
        return HStack {
            AsyncRemoteImage(url: coin.iconUrl)
                .frame(width: 64, height: 64)
                .padding(.trailing, 10)
            VStack(alignment: .leading) {
                HStack {
                    Text(coin.name)
                        .font(.headline)
                        .foregroundColor(.init(hex: coin.color))
                    Text("(\(coin.symbol))")
                }
                HStack {
                    Text("PRICE ")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.primary.opacity(0.9))
                    Text("$ \(coin.price, specifier: "%.2f")")
                }
                HStack {
                    Text("MARKET CAP ")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.primary.opacity(0.9))
                    let mc = marketCapFormatter(coin.marketCap)
                    Text("$ \(mc.value, specifier: "%.2f") \(mc.suffix)")
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity,
               minHeight: 80, maxHeight: 80)
    }
    
    /// The header contains the `X` mark for dismiss this view
    var header: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(.title2))
                        .foregroundColor(.primary)
                }
                .padding()
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct CoinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CoinDetailView(coin: .sampleCoin)
    }
}
