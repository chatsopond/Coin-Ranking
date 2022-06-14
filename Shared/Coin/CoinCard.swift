//
//  CoinCard.swift
//  LMWN Coin 2 Tests
//
//  Created by Chatsopon Deepateep on 15/6/2565 BE.
//

import SwiftUI

enum CoinCardType {
    case row, column
}

struct CoinCard: View {
    
    let type: CoinCardType
    let coin: Coin
    
    var body: some View {
        CardRectangle()
            .overlay(content)
            .frame(height: type == .row ? 82 : 140)
    }
    
    var content: some View {
        rowOrColumnContent
            .padding(.horizontal, 16)
            .padding(.vertical, 21)
    }
    
    @ViewBuilder
    var rowOrColumnContent: some View {
        switch type {
        case .row:
            rowContent
        case .column:
            coloumnContent
        }
    }
    
    var rowContent: some View {
        HStack(spacing: 16) {
            AsyncRemoteImage(url: coin.iconUrl)
                .frame(width: 40, height: 40)
            VStack(alignment:.leading, spacing: 6) {
                Text(coin.name)
                    .font(.headline)
                Text(coin.symbol)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.coinSubheadline)
            }
            Spacer()
            VStack(alignment:.trailing, spacing: 6) {
                Text("$\(coin.price, specifier: "%.5f")")
                    .font(.subheadline.weight(.semibold))
                changeSection
            }
        }
    }
    
    var coloumnContent: some View {
        VStack(spacing: 8) {
            AsyncRemoteImage(url: coin.iconUrl)
                .frame(width: 40, height: 40)
            Text(coin.symbol)
                .font(.headline.weight(.semibold))
                .foregroundColor(.coinSubheadline)
            Text(coin.name)
                .font(.subheadline)
            changeSection
        }
    }
    
    var changeSection: some View {
        (
            Text(Image(systemName:
                        coin.change > 0 ? "arrow.up" :
                        coin.change < 0 ? "arrow.down" :
                        "minus"
                      )) +
            Text(" \(abs(coin.change), specifier: "%.2f")")
        )
        .font(.subheadline.weight(.semibold))
        .foregroundColor(
            coin.change > 0 ? Color.green :
                coin.change < 0 ? Color.red :
                Color.primary
        )
    }
}

struct CoinCard_Previews: PreviewProvider {
    static var previews: some View {
        CoinCard(type: .row, coin: .sampleCoin)
            .previewLayout(.sizeThatFits)
            .padding()
        
        CoinCard(type: .column, coin: .sampleCoin)
            .frame(width: 110)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
