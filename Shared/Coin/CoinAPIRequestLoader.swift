//
//  CoinAPIRequestLoader.swift
//  LMWN Coin 2
//
//  Created by Chatsopon Deepateep on 15/6/2565 BE.
//

import Foundation
import os

enum CoinAPIRequestLoaderError: Error {
    case invalidResponse, invalidFormat, invalidStatus
}

extension CoinAPIRequestLoaderError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response (statusCode != 200)"
        case .invalidFormat:
            return "Invalid Format: Cannot convert to CoinResponse"
        case .invalidStatus:
            return "Invalid response status (status != success)"
        }
    }
}

class CoinAPIRequestLoader {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                category: String(describing: CoinAPIRequestLoader.self))
    private let apiUrl = "https://api.coinranking.com/v2/"
    
    var urlSession: URLSession = URLSession.shared
    
    private func makeGetCoinsRequest(limit: Int, offset: Int, search: String) -> URLRequest {
        let url = URL(string: apiUrl + "coins?limit=\(limit)&offset=\(offset)&search=\(search)")!
        return URLRequest(url: url)
    }
    
    func loadGetCoinsRequest(limit: Int = 10, offset: Int, search: String = "") async throws -> [Coin] {
        let searchParam = search.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let request = makeGetCoinsRequest(limit: limit, offset: offset, search: searchParam)
        let (data, response) = try await urlSession.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.warning("can't convert response to HTTPURLResponse")
            throw CoinAPIRequestLoaderError.invalidResponse
        }
        guard httpResponse.statusCode == 200 else {
            logger.warning("statusCode != 200, \(httpResponse.statusCode)")
            throw CoinAPIRequestLoaderError.invalidResponse
        }
        // Development purpose
        // Check the error when decode fail
//        do {
//            _ = try JSONDecoder().decode(CoinAPIResponse.self, from: data)
//        } catch {
//            print("\(error)")
//        }
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            let dataString = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            logger.warning("\(#function) - cannot get jsonObject from data, \(String(describing: dataString))")
            throw CoinAPIRequestLoaderError.invalidFormat
        }
        guard let status = jsonObject["status"] as? String,
              status == "success" else {
            logger.warning("\(#function) - status doesn't return success")
            throw CoinAPIRequestLoaderError.invalidFormat
        }
        guard let data = jsonObject["data"] as? [String: Any],
              let coins = data["coins"] as? [[String: Any]] else {
            logger.warning("\(#function) - can't access coins")
            throw CoinAPIRequestLoaderError.invalidFormat
        }
        // Some information may not meet all the required fields eg. price, name,…
        // We will convert one by one
        var result: [Coin] = []
        for coin in coins {
            guard let json = try? JSONSerialization.data(withJSONObject: coin),
                  let decodedCoin = try? JSONDecoder().decode(Coin.self, from: json) else { continue }
            result.append(decodedCoin)
        }
        return result
        
        // MARK: ARCHIVED
        // Some coin has no important field eg. price
//        guard let resp = try? JSONDecoder().decode(CoinAPIResponse.self, from: data) else {
//            logger.warning("\(#function) - cannot decode json, \(String(describing: dataString))")
//            throw CoinAPIRequestLoaderError.invalidFormat
//        }
//        return resp.data.coins
    }
}

extension CoinAPIRequestLoader {
    private func makeGetCoinRequest(uuid: String) -> URLRequest {
        let safeUUID = uuid.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let url = URL(string: apiUrl + "coin/\(safeUUID)")!
        print(url)
        return URLRequest(url: url)
    }
    
    func loadGetCoinDetailRequest(uuid: String) async throws -> CoinDetail {
        let request = makeGetCoinRequest(uuid: uuid)
        let (data, response) = try await urlSession.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.warning("can't convert response to HTTPURLResponse")
            throw CoinAPIRequestLoaderError.invalidResponse
        }
        guard httpResponse.statusCode == 200 else {
            logger.warning("statusCode != 200, \(httpResponse.statusCode)")
            throw CoinAPIRequestLoaderError.invalidResponse
        }
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let status = jsonObject["status"] as? String,
              status == "success" else {
            logger.warning("invalid status, status != success")
            throw CoinAPIRequestLoaderError.invalidStatus
        }
        guard let data = jsonObject["data"] as? [String: Any],
              let coinDetail = data["coin"] as? [String: Any] else {
            logger.warning("\(#function) - can't access coin field")
            throw CoinAPIRequestLoaderError.invalidFormat
        }
        guard let jsonCoin = try? JSONSerialization.data(withJSONObject: coinDetail),
              var coinDetail = try? JSONDecoder().decode(CoinDetail.self, from: jsonCoin) else {
            logger.warning("\(#function) - can't convert to coinDetail")
            throw CoinAPIRequestLoaderError.invalidFormat
        }
        coinDetail.uuid = uuid
        return coinDetail
    }
}
