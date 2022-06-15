//
//  Coin.swift
//  LMWN Coin 2
//
//  Created by Chatsopon Deepateep on 15/6/2565 BE.
//

import Foundation
import os

/// The cryptocurrency coin
struct Coin: Decodable, Identifiable, Hashable {
    var uuid: String
    var symbol: String
    var name: String
    var color: String
    var iconUrl: URL
    var marketCap: Double
    var price: Double
    var change: Double
    var rank: Int
    
    /// Identifiable variable
    var id: String { uuid }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    
    private enum CodingKeys: String, CodingKey {
        case uuid, symbol, name, color, iconUrl, marketCap, price, change, rank
    }
    
    private enum CoinDecodeError: Error {
        case iconUrl, marketCap, price, change
    }
    
    init(
        uuid: String,
        symbol: String,
        name: String,
        color: String,
        iconUrl: URL,
        marketCap: Double,
        price: Double,
        change: Double,
        rank: Int
    ) {
        self.uuid = uuid
        self.symbol = symbol
        self.name = name
        self.color = color
        self.iconUrl = iconUrl
        self.marketCap = marketCap
        self.price = price
        self.change = change
        self.rank = rank
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let uuid = try container.decode(String.self, forKey: .uuid)
        let symbol = try container.decode(String.self, forKey: .symbol)
        let name = try container.decode(String.self, forKey: .name)
        let color = (try? container.decode(String.self, forKey: .color)) ?? "#333333"
        let iconUrlString = try container.decode(String.self, forKey: .iconUrl)
        guard let iconUrl = URL(string: iconUrlString) else { throw CoinDecodeError.iconUrl }
        let marketCapString = (try? container.decode(String.self, forKey: .marketCap)) ?? "0"
        guard let marketCap = Double(marketCapString) else { throw CoinDecodeError.marketCap }
        let priceString = try container.decode(String.self, forKey: .price)
        guard let price = Double(priceString) else { throw CoinDecodeError.price }
        let changeString = try container.decode(String.self, forKey: .change)
        guard let change = Double(changeString) else { throw CoinDecodeError.change }
        let rank = try container.decode(Int.self, forKey: .rank)
        self.init(uuid: uuid,
                  symbol: symbol,
                  name: name,
                  color: color,
                  iconUrl: iconUrl,
                  marketCap: marketCap,
                  price: price,
                  change: change,
                  rank: rank)
    }
}

// MARK: - Sample

extension Coin {
    public static let sampleCoin = Coin(
        uuid: "Qwsogvtv82FCd",
        symbol: "BTC",
        name: "Bitcoin",
        color: "#f7931A",
        iconUrl: URL(string:"https://cdn.coinranking.com/Sy33Krudb/btc.svg")!,
        marketCap: Double("159393904304")!,
        price: Double("9370.9993109108")!,
        change: Double("-0.52")!,
        rank: 1
    )
}
